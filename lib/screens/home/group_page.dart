import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_dart/hue_dart.dart' hide Timer;
import 'package:lumi/components/tiny_light_card.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/colors.dart';
import 'package:supercharged/supercharged.dart';

class GroupPage extends StatefulWidget {
  final Group group;

  GroupPage({
    @required this.group,
  });

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool isLoading = false;
  bool groupOn;
  bool timeInitialized = false;

  DateTime localTime;

  double brightness;
  double saturation;
  double hue;

  Group group;

  Timer timerUpdate;
  Timer timerUpdateBrightness;
  Timer timerUpdateSaturation;
  Timer timerUpdateHue;

  @override
  void initState() {
    super.initState();

    setState(() {
      group       = widget.group;
      groupOn     = group.action.on;
      brightness  = group.action.brightness.toDouble();
      hue         = group.action.hue?.toDouble();
      saturation  = group.action.saturation?.toDouble();
    });
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

          groupType(),
          lightsCount(),

          if (groupOn)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                brightnessSlider(),

                if (saturation != null)
                  saturationSlider(),

                if (hue != null)
                  hueContainer(),

                groupLights(),
              ],
            ),
        ],
      ),
    );
  }

  Widget brightnessSlider() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 60.0,
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

          Row(
            children: [
              SizedBox(
                width: 250.0,
                child: Slider(
                  value: brightness,
                  min: 0,
                  max: 254,
                  activeColor: groupOn
                    ? stateColors.primary
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
                        final action = GroupAction(
                          (g) => g..brightness = brightness.toInt()
                        );

                        userState.bridge.updateGroupState(
                          group.rebuild(
                            (g) => g..action = action.toBuilder()
                          )
                        ).then((_) => fetch());
                      }
                    );
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
    );
  }

  Widget hueSlider() {
    return SizedBox(
      width: 250.0,
      child: SliderTheme(
        data: SliderThemeData(
          activeTrackColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          thumbColor: Color.fromRGBO(255, 255, 255, 0.9),
        ),
        child: Slider(
          value: hue,
          min: 0,
          max: 65535,
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
                final action = GroupAction(
                  (g) => g..hue = hue.toInt()
                );

                userState.bridge.updateGroupState(
                  group.rebuild(
                    (g) => g..action = action.toBuilder()
                  )
                ).then((_) => fetch());
              }
            );
          },
        ),
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
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
            ),
          ),

          IconButton(
            onPressed: () async {
              setState(() => groupOn = !group.action.on);

              final action = GroupAction(
                (g) => g..on = !group.action.on
              );

              await userState.bridge.updateGroupState(
                group.rebuild(
                  (g) => g..action = action.toBuilder()
                )
              );

              fetch();
            },
            icon: Icon(
              Icons.kitchen,
              size: 35.0,
              color: group.action.on
                ? stateColors.primary
                : stateColors.foreground.withOpacity(0.6),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Opacity(
              opacity: 0.7,
              child: Text(
                group.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w500,
                )
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
              groupOn
                ? 'ON'
                : 'OFF',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
            ),
          ),

          Switch(
            value: groupOn,
            activeColor: stateColors.primary,
            onChanged: (isOn) async {
              setState(() => groupOn = isOn);

              final action = GroupAction(
                (g) => g..on = isOn
              );

              await userState.bridge.updateGroupState(
                group.rebuild(
                  (g) => g..action = action.toBuilder()
                )
              );
            },
          ),
        ],
      ),
    );
  }

  Widget groupType() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 74.0,
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getGroupIcon(),

          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                group.type,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget groupLights() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 74.0,
        vertical: 30.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                'LIGHTS',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: group.lightIds.map((id) {
              return TinyLightCard(id: id);
            }).toList()
          ),
        ],
      ),
    );
  }

  Widget lightCard(String id) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
            ),

            Opacity(
              opacity: 0.6,
              child: Text(
                id,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget lightsCount() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 74.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                lightsCountText(),
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget hueContainer() {
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

          Stack(
            children: [
              Container(
                width: 220.0,
                height: 15.0,
                margin: const EdgeInsets.only(
                  left: 20.0,
                  top: 16.0,
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

              hueSlider(),
            ]),
        ],
      ),
    );
  }

  Icon getGroupIcon() {
    return Icon(
      Icons.kitchen,
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
              activeColor: stateColors.primary,

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
                    final action = GroupAction(
                      (g) => g..saturation = saturation.toInt()
                    );

                    userState.bridge.updateGroupState(
                      group.rebuild(
                        (g) => g..action = action.toBuilder()
                      )
                    ).then((_) => fetch());
                  }
                );
              },
            ),
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

    timerUpdate = Timer(
      150.milliseconds,
      () async {
        try {
          final newGroup = await userState.bridge.group(group.id);

          if (!mounted) {
            return;
          }

          setState(() {
            isLoading = false;
            group = newGroup;
          });

        } catch (error) {
          debugPrint(error.toString());
          setState(() => isLoading = false);
        }
      }
    );
  }

  String lightsCountText() {
    final count = group.lightIds.length;
    final suffix = count > 1
      ? 'lights'
      : 'light';

    return '$count $suffix';
  }
}
