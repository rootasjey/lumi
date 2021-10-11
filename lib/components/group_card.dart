import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class GroupCard extends StatefulWidget {
  final double elevation;

  final Group group;

  final VoidCallback onTap;
  final VoidCallback onToggle;

  const GroupCard({
    Key key,
    @required this.group,
    this.onTap,
    this.onToggle,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> with TickerProviderStateMixin {
  Animation<double> _scaleAnimation;
  AnimationController _scaleAnimationController;

  @override
  initState() {
    super.initState();

    _scaleAnimationController = AnimationController(
      lowerBound: 0.8,
      upperBound: 1.0,
      duration: 250.milliseconds,
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;

    return ScaleTransition(
      scale: _scaleAnimation,
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
                _scaleAnimationController.forward();
                return;
              }

              _scaleAnimationController.reverse();
            },
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
                          group.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: FontsUtils.mainStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.6,
                        child: Text(
                          group.type,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4.0,
                        ),
                        child: Opacity(
                          opacity: 0.6,
                          child: Text(
                            "lights_number".plural(group.lightIds.length),
                            overflow: TextOverflow.ellipsis,
                            style: FontsUtils.mainStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
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

  Widget toggleButton() {
    final group = widget.group;

    return Positioned(
      top: 20.0,
      left: 20.0,
      child: IconButton(
        tooltip:
            group.action.on ? "turn_scene_off".tr() : "turn_scene_off".tr(),
        onPressed: widget.onToggle,
        icon: Icon(
          UniconsLine.bed_double,
          size: 30.0,
          color: group.action.on
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
