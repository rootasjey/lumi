import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/state/colors.dart';
import 'package:supercharged/supercharged.dart';

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
  Animation<double> scaleAnimation;
  AnimationController scaleAnimationController;

  bool isLoading = false;

  Timer timerUpdate;

  @override
  initState() {
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
    final group = widget.group;

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
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: Text(
                          group.name,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.6,
                        child: Text(
                          group.type,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4.0,
                        ),
                        child: Opacity(
                          opacity: 0.6,
                          child: Text(
                            '${group.lightIds.length} lights',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20.0,
                  left: 20.0,
                  child: IconButton(
                    tooltip: group.action.on
                        ? 'Turn OFF this scene'
                        : 'Turn ON this scene',
                    onPressed: widget.onToggle,
                    icon: Icon(
                      Icons.kitchen,
                      size: 30.0,
                      color: group.action.on
                          ? stateColors.primary
                          : stateColors.foreground.withOpacity(0.6),
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
}
