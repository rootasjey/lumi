import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:jiffy/jiffy.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/app_logger.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class SensorPage extends StatefulWidget {
  final Sensor sensor;
  final String sensorId;

  SensorPage({
    this.sensor,
    this.sensorId,
  });

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  DateTime _localTime;
  Sensor _sensor;

  bool _isLoading = false;
  bool _sensorOn;
  bool _timeInitialized = false;

  Color _cardColor = stateColors.appBackground;

  double _cardWidth = 500.0;
  double _cardElevation = 4.0;

  Timer _timerUpdate;

  @override
  void initState() {
    super.initState();

    setState(() {
      _sensor = widget.sensor;
      _sensorOn = _sensor.config.on;
    });

    initLocalTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(automaticallyImplyLeading: true),
          SliverPadding(
            padding: const EdgeInsets.only(
              bottom: 400.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                header(),
                powerSwitch(),
                if (_sensorOn)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      batteryLevel(),
                      lastDetected(),
                    ],
                  ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        left: 60.0,
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              iconSize: 40.0,
              onPressed: () => onToggle(!_sensorOn),
              icon: Icon(
                UniconsLine.dice_one,
                color: _sensorOn
                    ? stateColors.primary
                    : stateColors.foreground.withOpacity(0.6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                _sensor.name,
                style: FontsUtils.mainStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget powerSwitch() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 74.0,
      ),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            _sensorOn ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: _sensorOn,
            activeColor: stateColors.primary,
            onChanged: (isOn) => onToggle(isOn),
          ),
        ],
      ),
    );
  }

  Widget batteryLevel() {
    return Container(
      width: _cardWidth,
      padding: const EdgeInsets.only(
        top: 40.0,
        left: 50.0,
        bottom: 20.0,
      ),
      child: Card(
        elevation: _cardElevation,
        color: _cardColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                ),
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    "battery_level".tr(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: "battery_remaining".tr(
                  args: [
                    _sensor.config.battery.toString(),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                        left: 20.0,
                      ),
                      child: Icon(
                        _sensor.config.battery < 5
                            ? UniconsLine.battery_bolt
                            : UniconsLine.battery_empty,
                        color: _sensor.config.battery < 5
                            ? Colors.red.shade300
                            : stateColors.foreground,
                      ),
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        '${_sensor.config.battery}%',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lastDetected() {
    final presence = _sensor.state.presence ?? false;

    return SizedBox(
      width: _cardWidth,
      child: Card(
        margin: const EdgeInsets.only(
          top: 20.0,
          left: 54.0,
        ),
        elevation: _cardElevation,
        color: _cardColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    "motion".tr(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                    ),
                    child: Icon(
                      UniconsLine.bolt,
                      color: Colors.orange,
                      size: 30.0,
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "sensor_active".tr(
                        args: [
                          presence ? "yes".tr() : "no".tr(),
                        ],
                      ),
                      style: FontsUtils.mainStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ),
              ),
              if (_timeInitialized)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: Icon(
                        UniconsLine.clock,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        "sensor_last".tr(args: [Jiffy(_localTime).fromNow()]),
                        style: FontsUtils.mainStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fetch a single sensor's data.
  void fetch() async {
    if (_isLoading && _timerUpdate != null) {
      _timerUpdate.cancel();
    }

    _isLoading = true;

    _timerUpdate = Timer(150.milliseconds, () async {
      try {
        final newSensor = await userState.bridge.sensor(_sensor.id.toString());

        if (!mounted) {
          return;
        }

        setState(() {
          _isLoading = false;
          _sensor = newSensor;
          initLocalTime();
        });
      } catch (error) {
        setState(() => _isLoading = false);
        appLogger.e(error);
      }
    });
  }

  void initLocalTime() async {
    await Jiffy.locale('fr');

    if (_sensor.state.lastUpdated == null ||
        _sensor.state.lastUpdated.contains('none')) {
      return;
    }

    final utcTime = DateTime.parse(_sensor.state.lastUpdated);

    _localTime = DateTime.utc(
      utcTime.year,
      utcTime.month,
      utcTime.day,
      utcTime.hour,
      utcTime.minute,
      utcTime.second,
    ).toLocal();

    setState(() => _timeInitialized = true);
  }

  void onToggle(bool isOn) {
    setState(() => _sensorOn = isOn);

    userState.bridge
        .updateSensorConfig(_sensor.rebuild((s) => s..config.on = isOn))
        .then((_) => fetch())
        .catchError((err) => setState(() => _sensorOn = !isOn));
  }
}
