import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:jiffy/jiffy.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class SensorPage extends StatefulWidget {
  final Sensor sensor;

  SensorPage({
    @required this.sensor,
  });

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  DateTime localTime;
  Sensor sensor;

  bool isLoading = false;
  bool sensorOn;
  bool timeInitialized = false;

  double daylightSensivityValue;

  Timer timerUpdate;
  Timer timerUpdateBrightness;
  Timer timerUpdateSaturation;
  Timer timerUpdateHue;

  @override
  void initState() {
    super.initState();

    setState(() {
      sensor = widget.sensor;
      sensorOn = sensor.config.on;
      daylightSensivityValue = 0.0;
    });

    initLocalTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(
          bottom: 200.0,
        ),
        children: [
          header(),
          powerSwitch(),
          if (sensorOn)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                batteryLevel(),
                lastDetected(),
              ],
            ),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 40.0,
      ),
      child: Wrap(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 16.0,
            ),
            child: Icon(
              Icons.lightbulb_outline,
              size: 40.0,
              color: sensor.config.on
                  ? stateColors.primary
                  : stateColors.foreground.withOpacity(0.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Text(sensor.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }

  Widget powerSwitch() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 70.0,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 12.0,
            ),
            child: Text(
              sensor.config.on ? 'ON' : 'OFF',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: sensorOn,
            activeColor: stateColors.primary,
            onChanged: (isOn) async {
              setState(() => sensorOn = isOn);

              userState.bridge
                  .updateSensorConfig(
                      sensor.rebuild((s) => s..config.on = isOn))
                  .then((_) => fetch())
                  .catchError((err) => setState(() => sensorOn = !isOn));
            },
          ),
        ],
      ),
    );
  }

  Widget batteryLevel() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        left: 50.0,
        bottom: 20.0,
      ),
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
                'BATTERY LEVEL',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Tooltip(
            message:
                "${sensor.config.battery}% of battery remaining for this sensor",
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    left: 20.0,
                  ),
                  child: Icon(
                    sensor.config.battery < 5
                        ? Icons.battery_alert
                        : Icons.battery_full,
                    color: sensor.config.battery < 5
                        ? Colors.red.shade300
                        : stateColors.foreground,
                  ),
                ),
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '${sensor.config.battery}%',
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
    );
  }

  Widget lastDetected() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 74.0,
      ),
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
                'MOTION',
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
                  Icons.bolt,
                  color: Colors.orange,
                  size: 30.0,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Text(
                  'ACTIVE: ${sensor.state.presence}',
                  style: TextStyle(
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ),
                child: Icon(
                  Icons.timelapse,
                  color: Colors.blue,
                  size: 30.0,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Text(
                  timeInitialized ? 'LAST: ${Jiffy(localTime).fromNow()}' : '',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Fetch a single sensor's data.
  void fetch() async {
    if (isLoading && timerUpdate != null) {
      timerUpdate.cancel();
    }

    isLoading = true;

    timerUpdate = Timer(150.milliseconds, () async {
      try {
        final newSensor = await userState.bridge.sensor(sensor.id.toString());

        if (!mounted) {
          return;
        }

        setState(() {
          isLoading = false;
          sensor = newSensor;
          initLocalTime();
        });
      } catch (error) {
        debugPrint(error.toString());
        setState(() => isLoading = false);
      }
    });
  }

  void initLocalTime() async {
    await Jiffy.locale('fr');

    if (sensor.state.lastUpdated == null ||
        sensor.state.lastUpdated.contains('none')) {
      return;
    }

    final utcTime = DateTime.parse(sensor.state.lastUpdated);

    localTime = DateTime.utc(
      utcTime.year,
      utcTime.month,
      utcTime.day,
      utcTime.hour,
      utcTime.minute,
      utcTime.second,
    ).toLocal();

    setState(() => timeInitialized = true);
  }
}
