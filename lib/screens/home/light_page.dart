import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_dart/hue_dart.dart' hide Timer;
import 'package:lumi/components/color_card.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/colors.dart';
import 'package:random_color/random_color.dart';
import 'package:supercharged/supercharged.dart';

class LightPage extends StatefulWidget {
  final Light light;
  final Color color;

  LightPage({
    @required this.light,
    this.color,
  });

  @override
  _LightPageState createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  Light light;
  bool isLoading = false;

  double brightness = 0;
  double saturation = 0;
  double hue = 0;

  Color accentColor;

  Timer timerUpdate;
  Timer timerUpdateBrightness;
  Timer timerUpdateSaturation;
  Timer timerUpdateHue;

  RandomColor colorGenerator;

  final colors = <Color>[];

  @override
  void initState() {
    super.initState();

    colorGenerator = RandomColor();

    setState(() {
      light       = widget.light;
      brightness  = light.state.brightness.toDouble();
      saturation  = light.state.saturation.toDouble();
      hue         = light.state.hue.toDouble();
      accentColor = widget.color ?? stateColors.primary;
    });

    generatePalette();
    fetch();
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

          if (light.state.on)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                brightnessSlider(),
                saturationSlider(),
                lightHue(),
                colorsPalette(),
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
              color: light.state.on
                ? accentColor
                : stateColors.foreground.withOpacity(0.6),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Text(
              light.name.toUpperCase(),
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w600,
              )
            ),
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
              light.state.on
                ? 'ON'
                : 'OFF',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
            ),
          ),

          Switch(
            value: light.state.on,
            activeColor: accentColor,
            onChanged: (isOn) async {
              LightState state = LightState(
                (l) => l..on = isOn
              );

              await userState.bridge.updateLightState(
                light.rebuild(
                  (l) => l..state = state.toBuilder()
                )
              );

              fetch();
            },
          ),
        ],
      ),
    );
  }

  Widget brightnessSlider() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        left: 50.0,
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
                'BRIGHTNESS',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 250.0,
            child: Slider(
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

                if (timerUpdateBrightness != null) {
                  timerUpdateBrightness.cancel();
                }

                timerUpdateBrightness = Timer(
                  250.milliseconds,
                  () async {
                    LightState state = LightState(
                      (l) => l..brightness = value.toInt()
                    );

                    await userState.bridge.updateLightState(
                      light.rebuild(
                        (l) => l..state = state.toBuilder()
                      )
                    );

                    fetch();
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget saturationSlider() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 50.0,
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
                'SATURATION',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 250.0,
            child: Slider(
              value: saturation,
              min: 0,
              max: 254,
              activeColor: light.state.on
                ? accentColor
                : stateColors.foreground.withOpacity(0.4),

              inactiveColor: stateColors.foreground.withOpacity(0.4),
              label: saturation.round().toString(),

              onChanged: (double value) async {
                setState(() {
                  saturation = value;
                });

                if (timerUpdateSaturation != null) {
                  timerUpdateSaturation.cancel();
                }

                timerUpdateSaturation = Timer(
                  250.milliseconds,
                  () async {
                    LightState state = LightState(
                      (l) => l..saturation = value.toInt()
                    );

                    await userState.bridge.updateLightState(
                      light.rebuild(
                        (l) => l..state = state.toBuilder()
                      )
                    );

                    fetch();
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget lightHue() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 50.0,
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
                'HUE',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          colorSlider(),

          Container(
            width: 220.0,
            height: 40.0,
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Card(
              elevation: 4.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: HUE_COLORS)
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorSlider() {
    return SizedBox(
      width: 250.0,
      child: Slider(
        value: hue,
        min: 0,
        max: 65535,
        activeColor: light.state.on
          ? accentColor
          : stateColors.foreground.withOpacity(0.4),

        inactiveColor: stateColors.foreground.withOpacity(0.4),
        label: hue.round().toString(),
        onChanged: (double value) async {
          setState(() {
            hue = value;
          });

          if (timerUpdateHue != null) {
            timerUpdateHue.cancel();
          }

          timerUpdateHue = Timer(
            250.milliseconds,
            () async {
              var state = LightState(
                (l) => l..hue = value.toInt()
              );

              userState.bridge.updateLightState(
                light.rebuild(
                  (l) => l..state = state.toBuilder()
                )
              )
              .then((value) {
                fetch();
              });
            }
          );
        },
      ),
    );
  }

  Widget colorsPalette() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 80.0,
        vertical: 50.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
            ),
            child: Wrap(
              spacing: 20.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    'RANDOM PALETTE',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () => generatePalette(),
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: colors.map((color) {
              return ColorCard(
                color: color,
                onTap: () {
                  if (timerUpdateHue != null) {
                    timerUpdateHue.cancel();
                  }

                  timerUpdateHue = Timer(
                    250.milliseconds,
                    () async {
                      final state = lightStateForColorOnly(
                        light.changeColor(
                          red: color.red,
                          green: color.green,
                          blue: color.blue,
                        )
                      );

                      userState.bridge.updateLightState(
                        light.rebuild(
                          (l) => l..state = state.toBuilder()
                        )
                      )
                      .then((_) => fetch());
                    }
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
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

          final hsl = HSLColor.fromAHSL(
            1.0,
            light.state.hue / 65535 * 360,
            light.state.saturation / 255,
            light.state.brightness / 255,
          );

          setState(() {
            isLoading   = false;
            accentColor = hsl.toColor();
            brightness  = light.state.brightness.toDouble();
            saturation  = light.state.saturation.toDouble();
            hue         = light.state.hue.toDouble();
          });

        } catch (error) {
          debugPrint(error.toString());
          isLoading = false;
          setState(() {});
        }
      }
    );
  }

  void generatePalette() {
    setState(() {
      colors.clear();
      colors.addAll(colorGenerator.randomColors(count: 5));
    });
  }
}
