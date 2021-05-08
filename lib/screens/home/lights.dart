import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/light_card.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/screens/home/light_page.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {
  List<Light> lights = [];
  Exception error;

  bool isLoading = false;

  Timer pageUpdateTimer;
  Timer updateBrightnessTimer;

  final sliderValues = Map<int, double>();

  @override
  void initState() {
    super.initState();
    fetch(showLoading: true);
    startPolling();
  }

  @override
  dispose() {
    pageUpdateTimer?.cancel();
    updateBrightnessTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SliverList(
        delegate: SliverChildListDelegate([
          LoadingView(),
        ]),
      );
    }

    if (error != null && lights.length == 0) {
      return SliverList(
        delegate: SliverChildListDelegate([
          ErrorView(),
        ]),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300.0,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final light = lights[index];
          return LightCard(
            light: light,
            lightColor: getLightcolor(light),
            brightness: light.state.brightness.toDouble(),
            onTap: () => onTap(light),
            onToggle: () async {
              final isOn = light.state.on;

              LightState state = LightState((l) => l..on = !isOn);

              await userState.bridge.updateLightState(
                  light.rebuild((l) => l..state = state.toBuilder()));

              fetch();
            },
            onBrightnessChanged: (value, resetOverrideBrightness) {
              if (updateBrightnessTimer != null) {
                updateBrightnessTimer.cancel();
              }

              updateBrightnessTimer = Timer(250.milliseconds, () async {
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
        childCount: lights.length,
      ),
    );
  }

  void startPolling() async {
    pageUpdateTimer = Timer.periodic(
      2.seconds,
      (timer) {
        fetch(showLoading: false);
      },
    );
  }

  /// Fetch all lights' data.
  Future fetch({showLoading = false}) async {
    if (showLoading) {
      setState(() => isLoading = true);
    }

    try {
      lights = await userState.bridge.lights();

      final title =
          '${lights.length} ${lights.length > 0 ? 'lights' : 'light'}';

      userState.setHomeSectionTitle(title);

      lights.forEach((light) {
        sliderValues[light.id] = light.state.brightness.toDouble();
      });

      setState(() => isLoading = false);
    } on Exception catch (err) {
      setState(() {
        error = err;
        isLoading = false;
      });

      debugPrint(error.toString());
    }
  }

  Color getLightcolor(Light light) {
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

  void onTap(Light light) async {
    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent, // onTap doesn't work without this
              child: Hero(
                tag: light.id,
                child: Center(
                  child: Container(
                    width: 800,
                    padding: const EdgeInsets.all(80.0),
                    child: Card(
                      elevation: 8.0,
                      child: GestureDetector(
                        onTap: () {}, // to block parent onTap()
                        child: LightPage(
                          light: light,
                          // color: accentColor,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
