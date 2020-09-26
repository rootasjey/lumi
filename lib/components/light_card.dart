import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hue_dart/hue_dart.dart' hide Timer;
import 'package:lumi/screens/home/light_page.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class LightCard extends StatefulWidget {
  final Light light;

  LightCard({@required this.light});

  @override
  _LightCardState createState() => _LightCardState();
}

class _LightCardState extends State<LightCard> {
  bool isLoading = false;
  Color accentColor;

  double brightness;
  double elevation;
  Light light;

  Timer updateBrightnessTimer;
  Timer timerUpdate;

  @override
  void initState() {
    super.initState();

    setState(() {
      light = widget.light;
      brightness = light.state.brightness.toDouble();
      accentColor = stateColors.primary;
      updateElevation();
    });

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Hero(
          tag: light.id,
          child: Container(
            width: 240.0,
            height: 240.0,
            child: Card(
              elevation: elevation,
              child: InkWell(
                onTap: () => onNavigateToLightPage(light),
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
                            ? accentColor
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
      value: brightness,
      min: 0,
      max: 254,
      activeColor: light.state.on
        ? accentColor
        : stateColors.foreground.withOpacity(0.4),

      inactiveColor: stateColors.foreground.withOpacity(0.4),
      label: brightness.round().toString(),

      onChanged: (double value) async {
        setState(() {
          brightness = value;
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

  void onNavigateToLightPage(Light light) async {
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

  /// Fetch a single light's data.
  void fetch() async {
    if (isLoading && timerUpdate != null) {
      timerUpdate.cancel();
    }

    isLoading = true;

    timerUpdate = Timer(
      150.milliseconds,
      () async {
        try {
          light = await userState.bridge.light(light.id);

          if (!mounted) {
            return;
          }

          var color = accentColor;

          if (light.state.on) {
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
                color.red   + 100,
                color.green + 100,
                color.blue  + 100,
              );
            }
          }

          setState(() {
            isLoading   = false;
            accentColor = color;
            brightness  = light.state.brightness.toDouble();
            updateElevation();
          });

        } catch (error) {
          debugPrint(error.toString());
          isLoading = false;
          setState(() {});
        }
      }
    );
  }

  void updateElevation() {
    elevation = light.state.on
      ? 6.0
      : 0.0;
  }
}
