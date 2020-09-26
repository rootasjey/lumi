import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hue_dart/hue_dart.dart' hide Timer;
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/screens/home/light_page.dart';
import 'package:lumi/state/colors.dart';
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

  Timer updateBrightnessTimer;

  final sliderValues = Map<int, double>();

  @override
  void initState() {
    super.initState();
    fetch(showLoading: true);
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
          return card(light);
        },
        childCount: lights.length,
      ),
    );
  }

  Widget card(Light light) {
    return Observer(
      builder: (context) {
        return Hero(
          tag: light.id,
          child: Container(
            width: 240.0,
            height: 240.0,
            child: Card(
              elevation: 6.0,
              child: InkWell(
                onTap: () => onTapLightCard(light),
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
                              light.name,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          brightnessSlider(light),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 20.0,
                      left: 20.0,
                      child: IconButton(
                        tooltip: 'Turn ${light.state.on ? 'off' : 'on'}',
                        onPressed: () async {
                          final isOn = light.state.on;

                          LightState state = LightState(
                            (l) => l..on = !isOn
                          );

                          await userState.bridge.updateLightState(
                            light.rebuild(
                              (l) => l..state = state.toBuilder()
                            )
                          );

                          fetch();
                        },
                        icon: Icon(
                          Icons.lightbulb_outline,
                          size: 30.0,
                          color: light.state.on
                            ? stateColors.primary
                            : stateColors.foreground.withOpacity(0.6)
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
    );
  }

  Widget brightnessSlider(Light light) {
    return Slider(
      value: sliderValues[light.id],
      min: 0,
      max: 254,
      activeColor: light.state.on
        ? stateColors.primary
        : stateColors.foreground.withOpacity(0.4),

      inactiveColor: stateColors.foreground.withOpacity(0.4),
      label: sliderValues[light.id].round().toString(),

      onChanged: (double value) async {
        setState(() {
          sliderValues[light.id] = value;
        });

        if (updateBrightnessTimer != null) {
          updateBrightnessTimer.cancel();
        }

        updateBrightnessTimer = Timer(
          250.milliseconds,
          () async {
            LightState state = LightState(
              (l) => l..brightness = value.toInt()
            );

            if (!light.state.on) {
              state = LightState(
                (l) => l
                  ..on = true
                  ..brightness = value.toInt()
              );
            }

            await userState.bridge.updateLightState(
              light.rebuild(
                (l) => l..state = state.toBuilder()
              )
            );

            fetch();
          }
        );
      },
    );
  }

  /// Fetch all lights' data.
  void fetch({showLoading = false}) async {
    if (showLoading) {
      setState(() => isLoading = true);
    }

    try {
      lights = await userState.bridge.lights();

      final title = '${lights.length} ${lights.length > 0 ? 'lights' : 'light'}';
      userState.setHomeSectionTitle(title);

      lights.forEach((light) {
        sliderValues[light.id] = light.state.brightness.toDouble();
      });

      setState(() {
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

  void onTapLightCard(Light light) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return Scaffold(
            body: Hero(
              tag: light.id,
              child: Center(
                child: Container(
                  width: 800,
                  padding: const EdgeInsets.all(80.0),
                  child: Card(
                    elevation: 8.0,
                    child: LightPage(
                      id: light.id.toString(),
                      light: light,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      )
    );

    fetch();
  }
}
