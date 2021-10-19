import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/color_card.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/router/navigation_state_helper.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/app_logger.dart';
import 'package:lumi/utils/colors.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:random_color/random_color.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';
import 'package:window_manager/window_manager.dart';

class LightPage extends StatefulWidget {
  final Color color;
  final int lightId;

  LightPage({
    this.lightId,
    this.color,
  });

  @override
  _LightPageState createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> with WindowListener {
  bool _isLoading = false;

  double _brightness = 0;
  double _saturation = 0;
  double _hue = 0;

  double _cardWidth = 400.0;
  double _cardElevation = 4.0;

  Color _accentColor;

  final _colors = <Color>[];

  Light _light;

  RandomColor _colorGenerator;

  /// Polling fetch timer.
  Timer _fetchTimer;

  /// Schedule light's state update.
  Timer _updateLightTimer;

  /// Schedule light's brightness update.
  Timer _updateBrightnessTimer;

  /// Schedule light's saturation update.
  Timer _updateSaturationTimer;

  /// Schedule light's hue update.
  Timer _updateHueTimer;

  @override
  void initState() {
    super.initState();
    WindowManager.instance.addListener(this);
    // NOTE: Events listennrs are not fire without this.
    WindowManager.instance.isVisible();

    _colorGenerator = RandomColor();

    setState(() {
      _accentColor = widget.color ?? stateColors.primary;
      _light = NavigationStateHelper.light;
      refreshProps();
    });

    pollingFetch();
  }

  void refreshProps() {
    if (_light == null) {
      return;
    }

    HSLColor hsl;

    if (_light.state.hue != null) {
      hsl = HSLColor.fromAHSL(
        1.0,
        _light.state.hue / 65535 * 360,
        _light.state.saturation / 255,
        _light.state.brightness / 255,
      );
    }

    _accentColor = hsl != null ? hsl.toColor() : _accentColor;
    _brightness = _light.state.brightness.toDouble();
    _saturation = _light.state.saturation?.toDouble();
    _hue = _light.state.hue?.toDouble();

    if (_hue != null) {
      generatePalette();
    }
  }

  @override
  void dispose() {
    WindowManager.instance.removeListener(this);
    _fetchTimer?.cancel();
    _updateLightTimer?.cancel();
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
          appBar(),
          body(),
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

  Widget body() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 40.0,
        right: 40.0,
        bottom: 200.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          header(),
          powerSwitch(),
          if (_light != null && _light.state.on)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 18.0,
                    runSpacing: 18.0,
                    children: [
                      brightnessSlider(),
                      if (_saturation != null) saturationSlider(),
                      if (_hue != null) lightHue(),
                    ],
                  ),
                ),
                if (_hue != null) colorsPalette(),
              ],
            ),
        ]),
      ),
    );
  }

  Widget header() {
    Color colorBulb = AdaptiveTheme.of(context).theme.textTheme.bodyText1.color;

    if (_light != null && _light.state.on) {
      colorBulb = _accentColor;
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
              onPressed: () => onToggle(!_light.state.on),
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
                _light?.name ?? 'loading...',
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

    if (_light != null && _light.state.on) {
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
            value: _light?.state?.on ?? false,
            activeColor: _accentColor,
            onChanged: (isOn) => onToggle(isOn),
          ),
        ],
      ),
    );
  }

  Widget brightnessSlider() {
    Color activeColor = stateColors.foreground.withOpacity(0.4);

    if (_light != null && _light.state.on) {
      activeColor = _accentColor;
    }

    return Container(
      width: _cardWidth,
      child: Card(
        elevation: _cardElevation,
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
                      value: _brightness,
                      min: 0,
                      max: 254,
                      activeColor: activeColor,
                      inactiveColor: stateColors.foreground.withOpacity(0.4),
                      label: _brightness.round().toString(),
                      onChanged: (double value) async {
                        setState(() {
                          _brightness = value;
                        });

                        if (_updateBrightnessTimer != null) {
                          _updateBrightnessTimer.cancel();
                        }

                        _updateBrightnessTimer =
                            Timer(250.milliseconds, () async {
                          LightState state =
                              LightState((l) => l..brightness = value.toInt());

                          await userState.bridge.updateLightState(_light
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

    if (_light != null && _light.state.on) {
      activeColor = _accentColor;
    }

    return Container(
      width: _cardWidth,
      child: Card(
        elevation: _cardElevation,
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
                  value: _saturation,
                  min: 0,
                  max: 254,
                  activeColor: activeColor,
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
                      LightState state =
                          LightState((l) => l..saturation = value.toInt());

                      await userState.bridge.updateLightState(
                          _light.rebuild((l) => l..state = state.toBuilder()));

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

    if (_light != null && _light.state.on) {
      activeColor = _accentColor;
    }

    return SizedBox(
      width: 250.0,
      child: Slider(
        value: _hue,
        min: 0,
        max: 65535,
        activeColor: activeColor,
        inactiveColor: stateColors.foreground.withOpacity(0.4),
        label: _hue.round().toString(),
        onChanged: (double value) async {
          setState(() {
            _hue = value;
          });

          if (_updateHueTimer != null) {
            _updateHueTimer.cancel();
          }

          _updateHueTimer = Timer(250.milliseconds, () async {
            var state = LightState((l) => l..hue = value.toInt());

            userState.bridge
                .updateLightState(
                    _light.rebuild((l) => l..state = state.toBuilder()))
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
        horizontal: 50.0,
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
                  if (_updateHueTimer != null) {
                    _updateHueTimer.cancel();
                  }

                  _updateHueTimer = Timer(250.milliseconds, () async {
                    final state = lightStateForColorOnly(_light.changeColor(
                      red: color.red,
                      green: color.green,
                      blue: color.blue,
                    ));

                    userState.bridge
                        .updateLightState(
                            _light.rebuild((l) => l..state = state.toBuilder()))
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
  void fetch({bool showLoading = true}) async {
    if (_isLoading && _updateLightTimer != null) {
      _updateLightTimer.cancel();
    }

    if (showLoading) {
      setState(() => _isLoading = true);
    }

    _updateLightTimer = Timer(150.milliseconds, () async {
      try {
        final int lightId = _light?.id ?? widget.lightId;
        final Light newLight = await userState.bridge.light(lightId);

        if (!mounted) {
          return;
        }

        setState(() {
          _light = newLight;
          refreshProps();
        });
      } catch (error) {
        appLogger.e(error);
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

  void generatePalette() {
    setState(() {
      _colors.clear();
      _colors.addAll(_colorGenerator.randomColors(count: 5));
    });
  }

  void onToggle(bool isOn) async {
    LightState state = LightState((l) => l..on = isOn);

    await userState.bridge
        .updateLightState(_light.rebuild((l) => l..state = state.toBuilder()));

    fetch();
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
