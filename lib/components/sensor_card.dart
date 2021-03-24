import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/screens/home/sensor_page.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class SensorCard extends StatefulWidget {
  final Sensor sensor;

  SensorCard({@required this.sensor});

  @override
  _SensorCardState createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  bool isLoading = false;
  Color accentColor;

  double elevation;

  Sensor sensor;
  Timer timerUpdate;

  @override
  void initState() {
    super.initState();

    setState(() {
      sensor = widget.sensor;
      accentColor = stateColors.primary;
      updateElevation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: sensor.id,
      child: SizedBox(
        width: 240.0,
        height: 240.0,
        child: Card(
          elevation: elevation,
          child: InkWell(
            onTap: () => onNavigateToSensorPage(sensor),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: Text(
                          sensor.name,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
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
                ),
                Positioned(
                  top: 20.0,
                  left: 20.0,
                  child: IconButton(
                    tooltip: 'Turn ${sensor.config.on ? 'off' : 'on'}',
                    onPressed: () async {
                      final isOn = sensor.config.on;

                      await userState.bridge.updateSensorConfig(
                          sensor.rebuild((s) => s..config.on = !isOn));

                      fetch();
                    },
                    icon: Icon(
                      Icons.sensor_window_outlined,
                      size: 30.0,
                      color: sensor.config.on
                          ? stateColors.primary
                          : stateColors.foreground.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onNavigateToSensorPage(Sensor sensor) async {
    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent, // onTap doesn't work without this
              child: Hero(
                tag: sensor.id,
                child: Center(
                  child: Container(
                    width: 800,
                    padding: const EdgeInsets.all(80.0),
                    child: Card(
                      elevation: 8.0,
                      child: GestureDetector(
                        onTap: () {}, // to block parent onTap()
                        child: SensorPage(
                          sensor: sensor,
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

    fetch();
  }

  /// Fetch a single light's data.
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
          updateElevation();
        });
      } catch (error) {
        debugPrint(error.toString());
        setState(() => isLoading = false);
      }
    });
  }

  void updateElevation() {
    elevation = sensor.config.on ? 6.0 : 0.0;
  }
}
