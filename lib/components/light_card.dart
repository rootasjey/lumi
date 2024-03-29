import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class LightCard extends StatefulWidget {
  final Color lightColor;
  final double brightness;

  final Light light;

  final Function(double, VoidCallback) onBrightnessChanged;

  final VoidCallback onToggle;
  final VoidCallback onTap;

  final double elevation;

  const LightCard({
    Key key,
    @required this.light,
    this.onToggle,
    this.onTap,
    this.onBrightnessChanged,
    this.lightColor,
    this.brightness = 0.0,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  _LightCardState createState() => _LightCardState();
}

class _LightCardState extends State<LightCard> with TickerProviderStateMixin {
  Animation<double> scaleAnimation;
  AnimationController scaleAnimationController;

  bool _overrideBrightness = false;

  double _brightnessSliderValue = 0.0;

  Timer _brightnessUpdateTimer;

  @override
  void initState() {
    super.initState();

    setState(() {
      _brightnessSliderValue = widget.light.state.brightness.toDouble();
    });

    scaleAnimationController = AnimationController(
      lowerBound: 0.8,
      upperBound: 1.0,
      duration: 250.milliseconds,
      vsync: this,
    );

    scaleAnimation = CurvedAnimation(
      parent: scaleAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _brightnessUpdateTimer?.cancel();
    scaleAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final light = widget.light;

    return ScaleTransition(
      scale: scaleAnimation,
      child: SizedBox(
        width: 240.0,
        height: 240.0,
        child: Card(
          elevation: widget.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.transparent),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: widget.onTap,
            onHover: (isHover) {
              if (isHover) {
                scaleAnimationController.forward();
                return;
              }

              scaleAnimationController.reverse();
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      name(),
                      brightnessSlider(light),
                    ],
                  ),
                ),
                toggleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget brightnessSlider(Light light) {
    final Color foreground =
        AdaptiveTheme.of(context).theme.textTheme.bodyText1.color;

    return Slider(
      value: _overrideBrightness ? _brightnessSliderValue : widget.brightness,
      min: 0,
      max: 254,
      activeColor:
          light.state.on ? widget.lightColor : foreground.withOpacity(0.4),
      inactiveColor: foreground.withOpacity(0.4),
      label: _overrideBrightness
          ? _brightnessSliderValue.round().toString()
          : widget.brightness.round().toString(),
      onChanged: (double value) async {
        setState(() {
          _overrideBrightness = true;
          _brightnessSliderValue = value;
        });

        _brightnessUpdateTimer = Timer(500.milliseconds, () {
          widget.onBrightnessChanged(value, resetOverrideBrightness);
        });
      },
    );
  }

  Widget name() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Text(
        widget.light.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget toggleButton() {
    final light = widget.light;

    return Positioned(
      top: 20.0,
      left: 20.0,
      child: IconButton(
        tooltip: 'Turn ${light.state.on ? 'off' : 'on'}',
        onPressed: widget.onToggle,
        icon: Icon(
          UniconsLine.lightbulb_alt,
          size: 25.0,
          color: light.state.on
              ? widget.lightColor
              : AdaptiveTheme.of(context)
                  .theme
                  .textTheme
                  .bodyText1
                  .color
                  .withOpacity(0.6),
        ),
      ),
    );
  }

  void resetOverrideBrightness() {
    setState(() => _overrideBrightness = false);
  }
}
