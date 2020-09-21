import 'package:flutter/material.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scrollController = ScrollController();
  List<Sensor> sensors = [];
  Exception error;

  bool isLoading = false;

  /// Selected tab (sensors, lights, scenes, ...).
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSensors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          HomeAppBar(
            title: Text(
              'lumi',
              style: TextStyle(
                fontSize: 50.0,
              ),
            ),
            onTapIconHeader: () {
              scrollController.animateTo(
                0,
                duration: 250.milliseconds,
                curve: Curves.decelerate,
              );
            },
          ),

          navigation(),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 100.0,
              vertical: 80.0,
            ),
            sliver: body(),
          ),
        ],
      ),
    );
  }

  Widget navigation() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          height: 100.0,
          padding: const EdgeInsets.only(
            top: 60.0,
            left: 100.0,
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              navButton(
                title: 'SENSORS',
                index: 0,
              ),

              navButton(
                title: 'LIGHTS',
                index: 1,
              ),

              navButton(
                title: 'SCENES',
                index: 2,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget navButton({
    String title,
    int index = 0,
  }) {

    Widget childButton;

    if (index != selectedIndex) {
      childButton = FlatButton(
        onPressed: () => setState(() => selectedIndex = index),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      );

    } else {
      childButton = RaisedButton(
        onPressed: () => setState(() => selectedIndex = index),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: childButton,
    );
  }

  Widget body() {
    if (isLoading) {
      return SliverList(
        delegate: SliverChildListDelegate([
          LoadingView(),
        ]),
      );
    }

    if (error != null) {
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
          return sensorCard(sensor);
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
                    child: Opacity(
                      opacity: 0.6,
                      child: Text(
                        '${sensor.config.battery}%',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 20.0,
              left: 30.0,
              child: Opacity(
                opacity: 0.6,
                child: Icon(
                  Icons.sensor_window_outlined,
                  size: 30.0,
                ),
              ),
            ),

            Positioned(
              top: 10.0,
              right: 10.0,
              child: Switch(
                value: sensor.config.on ?? false,
                onChanged: (isOn) async {
                  await userState.bridge.updateSensorConfig(sensor.rebuild(
                    (s) => s..config.on = isOn));

                  fetchSensors();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchSensors() async {
    setState(() => isLoading = true);

    try {
      final sensorsItems = await userState.bridge.sensors();

      sensorsItems
        .retainWhere((s) => s.capabilities != null && s.capabilities.primary);

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
