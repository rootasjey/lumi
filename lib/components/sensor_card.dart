import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:supercharged/supercharged.dart';

class SensorCard extends StatefulWidget {
  final double elevation;

  final Sensor sensor;

  final VoidCallback onTap;
  final VoidCallback onToggle;

  const SensorCard({
    Key key,
    @required this.sensor,
    this.onTap,
    this.onToggle,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  _SensorCardState createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> with TickerProviderStateMixin {
  Animation<double> scaleAnimation;
  AnimationController scaleAnimationController;

  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
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
                texts(),
                toggleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget texts() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name(),
          battery(),
        ],
      ),
    );
  }

  Widget battery() {
    final sensor = widget.sensor;

    return Tooltip(
      message: "${sensor.config.battery}% of battery remaining for this sensor",
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: Icon(
              sensor.config.battery < 5
                  ? UniconsLine.battery_bolt
                  : UniconsLine.battery_empty,
              color: sensor.config.battery < 5
                  ? Colors.red.shade300
                  : AdaptiveTheme.of(context).theme.textTheme.bodyText1.color,
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              '${sensor.config.battery}%',
              style: FontsUtils.mainStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget name() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Text(
        widget.sensor.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: FontsUtils.mainStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget toggleButton() {
    final sensor = widget.sensor;

    return Positioned(
      top: 20.0,
      left: 20.0,
      child: IconButton(
        tooltip: 'Turn ${sensor.config.on ? 'off' : 'on'}',
        onPressed: widget.onToggle,
        icon: Icon(
          UniconsLine.dice_one,
          size: 25.0,
          color: sensor.config.on
              ? stateColors.primary
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
}
