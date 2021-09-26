import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/components/sensor_card.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/app_logger.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';

class SensorsPage extends StatefulWidget {
  @override
  _SensorsPageState createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  List<Sensor> _sensors = [];
  Exception _error;

  bool _isLoading = false;

  Timer _pageUpdateTimer;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchSensors(showLoading: true);
    startPolling();
  }

  @override
  void dispose() {
    _pageUpdateTimer?.cancel();
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

    if (_error != null && _sensors.length == 0) {
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
            final sensor = _sensors[index];
            return SensorCard(
              sensor: sensor,
              elevation: sensor.config.on ? 6.0 : 0.0,
              onToggle: () async {
                final isOn = sensor.config.on;

                await userState.bridge.updateSensorConfig(
                    sensor.rebuild((s) => s..config.on = !isOn));

                fetchSensors();
              },
              onTap: () => onNavigate(sensor),
            );
          },
          childCount: _sensors.length,
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
              "sensors_number".plural(_sensors.length),
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
        fetchSensors(showLoading: false);
      },
    );
  }

  void fetchSensors({showLoading = false}) async {
    if (showLoading) {
      setState(() => _isLoading = true);
    }

    try {
      final sensorsItems = await userState.bridge.sensors();

      sensorsItems
          .retainWhere((s) => s.capabilities != null && s.capabilities.primary);

      setState(() {
        _sensors = sensorsItems;
        _isLoading = false;
      });
    } on Exception catch (err) {
      setState(() {
        _error = err;
        _isLoading = false;
      });

      appLogger.e(err);
    }
  }

  void onNavigate(Sensor sensor) {
    context.currentBeamLocation.update(
      (state) => state.copyWith(
        pathBlueprintSegments: [
          'sensors',
          ':sensorId',
        ],
        pathParameters: {
          'lightId': sensor.id.toString(),
        },
      ),
    );
  }
}
