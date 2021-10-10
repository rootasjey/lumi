import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/color_card.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/app_logger.dart';
import 'package:lumi/utils/colors.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:random_color/random_color.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class LightPage extends StatefulWidget {
  final Color color;
  final Light light;
  final int lightId;

  LightPage({
    this.light,
    this.lightId,
    this.color,
  });

  @override
  _LightPageState createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  bool isLoading = false;

  Color _cardColor = stateColors.appBackground;

  double brightness = 0;
  double saturation = 0;
  double hue = 0;

  double _cardWidth = 400.0;
  double _cardElevation = 4.0;

  Color accentColor;

  final _colors = <Color>[];

  Light light;

  RandomColor colorGenerator;

  Timer timerUpdate;
  Timer timerUpdateBrightness;
  Timer timerUpdateSaturation;
  Timer timerUpdateHue;

  @override
  void initState() {
    super.initState();

    colorGenerator = RandomColor();

    setState(() {
      accentColor = widget.color ?? stateColors.primary;
      light = widget.light;

      if (light != null) {
        brightness = light.state.brightness.toDouble();
        saturation = light.state.saturation?.toDouble();
        hue = light.state.hue?.toDouble();
      }
    });

    if (hue != null) {
      generatePalette();
    }

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          appBar(),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 40.0,
              right: 40.0,
              bottom: 200.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                header(),
                powerSwitch(),
                if (light != null && light.state.on)
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Wrap(
                      spacing: 18.0,
                      runSpacing: 18.0,
                      children: [
                        brightnessSlider(),
                        if (saturation != null) saturationSlider(),
                        if (hue != null) lightHue(),
                        if (hue != null) colorsPalette(),
                      ],
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return HomeAppBar(
      automaticallyImplyLeading: true,
      title: Text(
        'lumi',
        style: FontsUtils.titleStyle(
          fontSize: 30.0,
        ),
      ),
    );
  }

  Widget header() {
    Color colorBulb = stateColors.foreground.withOpacity(0.6);

    if (light != null && light.state.on) {
      colorBulb = accentColor;
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        left: 45.0,
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: IconButton(
              iconSize: 40.0,
              onPressed: () => onToggle(!light.state.on),
              icon: Icon(
                UniconsLine.lightbulb_alt,
                color: colorBulb,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                light?.name ?? 'loading...',
                style: FontsUtils.mainStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget powerSwitch() {
    String stateStr = 'OFF';

    if (light != null && light.state.on) {
      stateStr = 'ON';
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 60.0,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 12.0,
            ),
            child: Text(
              stateStr,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: light?.state?.on ?? false,
            activeColor: accentColor,
            onChanged: (isOn) => onToggle(isOn),
          ),
        ],
      ),
    );
  }

  Widget brightnessSlider() {
    Color activeColor = stateColors.foreground.withOpacity(0.4);

    if (light != null && light.state.on) {
      activeColor = accentColor;
    }

    return Container(
      width: _cardWidth,
      child: Card(
        elevation: _cardElevation,
        color: _cardColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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
                    "brightness".tr().toUpperCase(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250.0,
                    child: Slider(
                      value: brightness,
                      min: 0,
                      max: 254,
                      activeColor: activeColor,
                      inactiveColor: stateColors.foreground.withOpacity(0.4),
                      label: brightness.round().toString(),
                      onChanged: (double value) async {
                        setState(() {
                          brightness = value;
                        });

                        if (timerUpdateBrightness != null) {
                          timerUpdateBrightness.cancel();
                        }

                        timerUpdateBrightness =
                            Timer(250.milliseconds, () async {
                          LightState state =
                              LightState((l) => l..brightness = value.toInt());

                          await userState.bridge.updateLightState(light
                              .rebuild((l) => l..state = state.toBuilder()));

                          fetch();
                        });
                      },
                    ),
                  ),
                  Icon(
                    Icons.wb_sunny,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget saturationSlider() {
    Color activeColor = stateColors.foreground.withOpacity(0.4);

    if (light != null && light.state.on) {
      activeColor = accentColor;
    }

    return Container(
      width: _cardWidth,
      child: Card(
        elevation: _cardElevation,
        color: _cardColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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
                  activeColor: activeColor,
                  inactiveColor: stateColors.foreground.withOpacity(0.4),
                  label: saturation.round().toString(),
                  onChanged: (double value) async {
                    setState(() {
                      saturation = value;
                    });

                    if (timerUpdateSaturation != null) {
                      timerUpdateSaturation.cancel();
                    }

                    timerUpdateSaturation = Timer(250.milliseconds, () async {
                      LightState state =
                          LightState((l) => l..saturation = value.toInt());

                      await userState.bridge.updateLightState(
                          light.rebuild((l) => l..state = state.toBuilder()));

                      fetch();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lightHue() {
    return SizedBox(
      width: _cardWidth,
      child: Card(
        elevation: _cardElevation,
        color: _cardColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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
                      gradient: LinearGradient(colors: HUE_COLORS),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorSlider() {
    Color activeColor = stateColors.foreground.withOpacity(0.4);

    if (light != null && light.state.on) {
      activeColor = accentColor;
    }

    return SizedBox(
      width: 250.0,
      child: Slider(
        value: hue,
        min: 0,
        max: 65535,
        activeColor: activeColor,
        inactiveColor: stateColors.foreground.withOpacity(0.4),
        label: hue.round().toString(),
        onChanged: (double value) async {
          setState(() {
            hue = value;
          });

          if (timerUpdateHue != null) {
            timerUpdateHue.cancel();
          }

          timerUpdateHue = Timer(250.milliseconds, () async {
            var state = LightState((l) => l..hue = value.toInt());

            userState.bridge
                .updateLightState(
                    light.rebuild((l) => l..state = state.toBuilder()))
                .then((value) {
              fetch();
            });
          });
        },
      ),
    );
  }

  Widget colorsPalette() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 70.0,
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
                  onPressed: generatePalette,
                  icon: Opacity(
                    opacity: 0.6,
                    child: Icon(UniconsLine.refresh),
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: _colors.map((color) {
              return ColorCard(
                color: color,
                onTap: () {
                  if (timerUpdateHue != null) {
                    timerUpdateHue.cancel();
                  }

                  timerUpdateHue = Timer(250.milliseconds, () async {
                    final state = lightStateForColorOnly(light.changeColor(
                      red: color.red,
                      green: color.green,
                      blue: color.blue,
                    ));

                    userState.bridge
                        .updateLightState(
                            light.rebuild((l) => l..state = state.toBuilder()))
                        .then((_) => fetch());
                  });
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

    timerUpdate = Timer(150.milliseconds, () async {
      try {
        final int lightId = light?.id ?? widget.lightId;
        light = await userState.bridge.light(lightId);

        if (!mounted) {
          return;
        }

        HSLColor hsl;

        if (light.state.hue != null) {
          hsl = HSLColor.fromAHSL(
            1.0,
            light.state.hue / 65535 * 360,
            light.state.saturation / 255,
            light.state.brightness / 255,
          );
        }

        setState(() {
          accentColor = hsl != null ? hsl.toColor() : accentColor;
          brightness = light.state.brightness.toDouble();
          saturation = light.state.saturation?.toDouble();
          hue = light.state.hue?.toDouble();
        });
      } catch (error) {
        appLogger.e(error);
      } finally {
        setState(() => isLoading = false);
      }
    });
  }

  void generatePalette() {
    setState(() {
      _colors.clear();
      _colors.addAll(colorGenerator.randomColors(count: 5));
    });
  }

  void onToggle(bool isOn) async {
    LightState state = LightState((l) => l..on = isOn);

    await userState.bridge
        .updateLightState(light.rebuild((l) => l..state = state.toBuilder()));

    fetch();
  }
}
