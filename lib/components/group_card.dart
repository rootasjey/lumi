import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/state/colors.dart';

class GroupCard extends StatefulWidget {
  final Group group;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const GroupCard({
    Key key,
    @required this.group,
    this.onTap,
    this.onToggle,
  }) : super(key: key);

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool isLoading = false;
  Color accentColor;

  double elevation;

  Timer timerUpdate;

  @override
  void initState() {
    super.initState();

    setState(() {
      accentColor = stateColors.primary;
      updateElevation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;

    return Hero(
      tag: group.id,
      child: SizedBox(
        width: 240.0,
        height: 240.0,
        child: Card(
          elevation: 6.0,
          child: InkWell(
            onTap: widget.onTap,
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

  void updateElevation() {
    elevation = widget.group.action.on ? 6.0 : 0.0;
  }
}
