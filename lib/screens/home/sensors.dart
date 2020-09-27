import 'package:flutter/material.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/components/sensor_card.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';

class Sensors extends StatefulWidget {
  @override
  _SensorsState createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  List<Sensor> sensors = [];
  Exception error;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSensors(showLoading: true);
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

    if (error != null && sensors.length == 0) {
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
          final sensor = sensors[index];
          // return sensorCard(sensor);
          return SensorCard(sensor: sensor);
        },
        childCount: sensors.length,
      ),
    );
  }

  Widget sensorCard(Sensor sensor) {
    return SizedBox(
      width: 240.0,
      height: 240.0,
      child: Card(
        elevation: 6.0,
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
                    message: "${sensor.config.battery}% of battery remaining for this sensor",
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
                onPressed: () async{
                  final isOn = sensor.config.on;

                  await userState.bridge.updateSensorConfig(
                    sensor.rebuild(
                      (s) => s..config.on = !isOn
                    )
                  );

                  fetchSensors();
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
    );
  }

  void fetchSensors({showLoading = false}) async {
    if (showLoading) {
      setState(() => isLoading = true);
    }

    try {
      final sensorsItems = await userState.bridge.sensors();

      sensorsItems
        .retainWhere((s) => s.capabilities != null && s.capabilities.primary);

      final title = '${sensorsItems.length} ${sensorsItems.length > 0 ? 'sensors' : 'sensor'}';
      userState.setHomeSectionTitle(title);

      setState(() {
        sensors = sensorsItems;
        isLoading = false;
      });

    } on Exception catch (err) {
      setState(() {
        error = err;
        isLoading = false;
      });

      debugPrint(error.toString());
    }
  }
}
