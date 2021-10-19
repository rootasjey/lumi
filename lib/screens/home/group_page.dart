import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/components/tiny_light_card.dart';
import 'package:lumi/router/navigation_state_helper.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/app_logger.dart';
import 'package:lumi/utils/colors.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';
import 'package:window_manager/window_manager.dart';

class GroupPage extends StatefulWidget {
  final int groupId;

  GroupPage({
    @required this.groupId,
  });

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with WindowListener {
  bool _isLoading = false;
  bool _isGroupOn = false;

  double _brightness = 0.0;
  double _saturation = 0.0;
  double _hue = 0.0;

  Group _group;

  /// Polling fetch timer.
  Timer _fetchTimer;

  /// Schedule group's state update.
  Timer _updateGroupTimer;

  /// Schedule group's brightness update.
  Timer _updateBrightnessTimer;

  /// Schedule group's saturation update.
  Timer _updateSaturationTimer;

  /// Schedule group's hue update.
  Timer _updateHueTimer;

  @override
  void initState() {
    super.initState();
    WindowManager.instance.addListener(this);
    // NOTE: Events listennrs are not fire without this.
    WindowManager.instance.isVisible();

    setState(() {
      _group = NavigationStateHelper.group;
      refreshProps();
    });

    pollingFetch();
  }

  void refreshProps() {
    if (_group == null) {
      return;
    }

    _isGroupOn = _group.action.on;
    _brightness = _group.action.brightness.toDouble();
    _hue = _group.action.hue?.toDouble();
    _saturation = _group.action.saturation?.toDouble();
  }

  @override
  void dispose() {
    WindowManager.instance.removeListener(this);
    _fetchTimer?.cancel();
    _updateGroupTimer?.cancel();
    _updateBrightnessTimer?.cancel();
    _updateSaturationTimer?.cancel();
    _updateHueTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(automaticallyImplyLeading: true),
          SliverPadding(
            padding: const EdgeInsets.only(
              bottom: 200.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                header(),
                powerSwitch(),
                groupTypeAndLights(),
                if (_isGroupOn)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      brightnessSlider(),
                      if (_saturation != null) saturationSlider(),
                      if (_hue != null) hueContainer(),
                      groupLights(),
                    ],
                  ),
              ]),
            ),
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
                  value: _brightness,
                  min: 0,
                  max: 254,
                  activeColor: _isGroupOn
                      ? stateColors.primary
                      : stateColors.foreground.withOpacity(0.4),
                  inactiveColor: stateColors.foreground.withOpacity(0.4),
                  label: _brightness.round().toString(),
                  onChanged: (double value) async {
                    setState(() {
                      _brightness = value;
                    });

                    if (_updateBrightnessTimer != null) {
                      _updateBrightnessTimer.cancel();
                    }

                    _updateBrightnessTimer = Timer(250.milliseconds, () async {
                      final action = GroupAction(
                          (g) => g..brightness = _brightness.toInt());

                      userState.bridge
                          .updateGroupState(_group
                              .rebuild((g) => g..action = action.toBuilder()))
                          .then((_) => fetch());
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
          value: _hue,
          min: 0,
          max: 65535,
          label: _hue.round().toString(),
          onChanged: (double value) async {
            setState(() {
              _hue = value;
            });

            if (_updateHueTimer != null) {
              _updateHueTimer.cancel();
            }

            _updateHueTimer = Timer(250.milliseconds, () async {
              final action = GroupAction((g) => g..hue = _hue.toInt());

              userState.bridge
                  .updateGroupState(
                      _group.rebuild((g) => g..action = action.toBuilder()))
                  .then((_) => fetch());
            });
          },
        ),
      ),
    );
  }

  Widget header() {
    Color iconColor = AdaptiveTheme.of(context).theme.textTheme.bodyText1.color;

    if (_group != null && _group.action.on) {
      iconColor = stateColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 60.0,
        right: 20.0,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          IconButton(
            iconSize: 40.0,
            onPressed: () async {
              setState(() => _isGroupOn = !_group.action.on);

              final action = GroupAction((g) => g..on = !_group.action.on);

              await userState.bridge.updateGroupState(
                  _group.rebuild((g) => g..action = action.toBuilder()));

              fetch();
            },
            icon: Icon(
              UniconsLine.bed_double,
              color: iconColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                _group?.name ?? 'loading...',
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
              _isGroupOn ? 'ON' : 'OFF',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: _isGroupOn,
            activeColor: stateColors.primary,
            onChanged: (isOn) async {
              setState(() => _isGroupOn = isOn);

              final action = GroupAction((g) => g..on = isOn);

              await userState.bridge.updateGroupState(
                  _group.rebuild((g) => g..action = action.toBuilder()));
            },
          ),
        ],
      ),
    );
  }

  Widget groupType() {
    return Row(
      children: [
        getGroupIcon(),
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
          ),
          child: Opacity(
            opacity: 0.6,
            child: Text(
              _group?.type ?? '',
              style: FontsUtils.mainStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget groupLights() {
    List<Widget> childrenLights = [];

    if (_group != null) {
      childrenLights = _group.lightIds.map((id) {
        return TinyLightCard(id: id);
      }).toList();
    }

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
            children: childrenLights,
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
    return Row(
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
          Stack(children: [
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
                        gradient: LinearGradient(colors: HUE_COLORS))),
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
              value: _saturation,
              min: 0,
              max: 254,
              activeColor: stateColors.primary,
              inactiveColor: stateColors.foreground.withOpacity(0.4),
              label: _saturation.round().toString(),
              onChanged: (double value) async {
                setState(() {
                  _saturation = value;
                });

                if (_updateSaturationTimer != null) {
                  _updateSaturationTimer.cancel();
                }

                _updateSaturationTimer = Timer(250.milliseconds, () async {
                  final action =
                      GroupAction((g) => g..saturation = _saturation.toInt());

                  userState.bridge
                      .updateGroupState(
                          _group.rebuild((g) => g..action = action.toBuilder()))
                      .then((_) => fetch());
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Fetch a single sensor's data.
  void fetch({bool showLoading = true}) async {
    if (_isLoading && _updateGroupTimer != null) {
      _updateGroupTimer.cancel();
    }

    if (showLoading) {
      setState(() => _isLoading = true);
    }

    _updateGroupTimer = Timer(150.milliseconds, () async {
      try {
        final int groupId = _group?.id ?? widget.groupId;
        final Group newGroup = await userState.bridge.group(groupId);

        if (!mounted) {
          return;
        }

        setState(() => _group = newGroup);
        refreshProps();
      } catch (error) {
        appLogger.e(error);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    });
  }

  String lightsCountText() {
    if (_group == null) {
      return '0 light';
    }

    final int count = _group.lightIds.length;
    final String suffix = count > 1 ? 'lights' : 'light';

    return '$count $suffix';
  }

  Widget groupTypeAndLights() {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 500.0,
          padding: const EdgeInsets.only(top: 60.0),
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  groupType(),
                  lightsCount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onWindowFocus() {
    if (_fetchTimer == null || !_fetchTimer.isActive) {
      pollingFetch();
    }

    super.onWindowFocus();
  }

  @override
  void onWindowBlur() {
    _fetchTimer?.cancel();
    super.onWindowBlur();
  }

  void pollingFetch() async {
    _fetchTimer = Timer.periodic(
      1.seconds,
      (timer) {
        fetch(showLoading: false);
      },
    );
  }
}
