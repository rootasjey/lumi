import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/components/sensor_card.dart';
import 'package:lumi/screens/home/sensor_page.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class Sensors extends StatefulWidget {
  @override
  _SensorsState createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  List<Sensor> sensors = [];
  Exception error;

  bool isLoading = false;

  Timer pageUpdateTimer;

  @override
  void initState() {
    super.initState();
    fetchSensors(showLoading: true);
    startPolling();
  }

  @override
  void dispose() {
    pageUpdateTimer?.cancel();
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
          return SensorCard(
              sensor: sensor,
              elevation: sensor.config.on ? 6.0 : 0.0,
              onToggle: () async {
                final isOn = sensor.config.on;

                await userState.bridge.updateSensorConfig(
                    sensor.rebuild((s) => s..config.on = !isOn));

                fetchSensors();
              },
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return Scaffold(
                      body: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          color: Colors
                              .transparent, // onTap doesn't work without this
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
              });
        },
        childCount: sensors.length,
      ),
    );
  }

  void startPolling() async {
    pageUpdateTimer = Timer.periodic(
      2.seconds,
      (timer) {
        fetchSensors(showLoading: false);
      },
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

      final title =
          '${sensorsItems.length} ${sensorsItems.length > 0 ? 'sensors' : 'sensor'}';
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
