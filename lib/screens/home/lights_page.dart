import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/components/light_card.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/app_logger.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';

class LightsPage extends StatefulWidget {
  @override
  _LightsPageState createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  List<Light> _lights = [];
  Exception _error;

  bool _isLoading = false;

  Timer _pageUpdateTimer;
  Timer _updateBrightnessTimer;

  final _sliderValues = Map<int, double>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetch(showLoading: true);
    startPolling();
  }

  @override
  dispose() {
    _pageUpdateTimer?.cancel();
    _updateBrightnessTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        appBar(),
        title(),
        body(),
      ],
    );
  }

  Widget appBar() {
    return HomeAppBar(
      title: Text(
        'lumi',
        style: FontsUtils.titleStyle(
          fontSize: 30.0,
        ),
      ),
      onTapIconHeader: () {
        _scrollController.animateTo(
          0,
          duration: 250.milliseconds,
          curve: Curves.decelerate,
        );
      },
    );
  }

  Widget body() {
    if (_isLoading) {
      return SliverList(
        delegate: SliverChildListDelegate([
          LoadingView(),
        ]),
      );
    }

    if (_error != null && _lights.length == 0) {
      return SliverList(
        delegate: SliverChildListDelegate([
          ErrorView(),
        ]),
      );
    }

    return gridView();
  }

  Widget gridView() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 100.0,
        right: 100.0,
        top: 40,
        bottom: 300.0,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300.0,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final light = _lights[index];
            return LightCard(
              light: light,
              elevation: light.state.on ? 6.0 : 0.0,
              lightColor: getLightColor(light),
              brightness: light.state.brightness.toDouble(),
              onTap: () => onNavigate(light),
              onToggle: () async {
                final isOn = light.state.on;

                LightState state = LightState((l) => l..on = !isOn);

                await userState.bridge.updateLightState(
                    light.rebuild((l) => l..state = state.toBuilder()));

                fetch();
              },
              onBrightnessChanged: (value, resetOverrideBrightness) {
                if (_updateBrightnessTimer != null) {
                  _updateBrightnessTimer.cancel();
                }

                _updateBrightnessTimer = Timer(250.milliseconds, () async {
                  LightState state =
                      LightState((l) => l..brightness = value.toInt());

                  if (!light.state.on) {
                    state = LightState((l) => l
                      ..on = true
                      ..brightness = value.toInt());
                  }

                  await userState.bridge.updateLightState(
                      light.rebuild((l) => l..state = state.toBuilder()));

                  await fetch();
                  resetOverrideBrightness();
                });
              },
            );
          },
          childCount: _lights.length,
        ),
      ),
    );
  }

  Widget title() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 100.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Opacity(
            opacity: 0.6,
            child: Text(
              "lights_number".plural(_lights.length),
              style: FontsUtils.titleStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void startPolling() async {
    _pageUpdateTimer = Timer.periodic(
      2.seconds,
      (timer) {
        fetch(showLoading: false);
      },
    );
  }

  /// Fetch all lights' data.
  Future fetch({showLoading = false}) async {
    if (showLoading) {
      setState(() => _isLoading = true);
    }

    try {
      _lights = await userState.bridge.lights();

      _lights.forEach((light) {
        _sliderValues[light.id] = light.state.brightness.toDouble();
      });

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } on Exception catch (err) {
      if (mounted) {
        setState(() {
          _error = err;
          _isLoading = false;
        });
      }

      appLogger.e(err);
    }
  }

  Color getLightColor(Light light) {
    Color color = Colors.yellow;

    if (light.state.on && light.state.hue != null) {
      final hsl = HSLColor.fromAHSL(
        1.0,
        light.state.hue / 65535 * 360,
        light.state.saturation / 255,
        light.state.brightness / 255,
      );

      color = hsl.toColor();

      if (color.red < 100 && color.green < 100 && color.blue < 100) {
        color = Color.fromARGB(
          color.alpha,
          color.red + 100,
          color.green + 100,
          color.blue + 100,
        );
      }
    }

    return color;
  }

  void onNavigate(Light light) async {
    context.currentBeamLocation.update(
      (state) => state.copyWith(
        pathBlueprintSegments: [
          'lights',
          ':lightId',
        ],
        pathParameters: {
          'lightId': light.id.toString(),
        },
      ),
    );
  }
}
