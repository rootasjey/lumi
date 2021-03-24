import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/screens/home/group_page.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class GroupCard extends StatefulWidget {
  final Group group;

  GroupCard({@required this.group});

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool isLoading = false;
  Color accentColor;

  double elevation;

  Group group;
  Timer timerUpdate;

  @override
  void initState() {
    super.initState();

    setState(() {
      group = widget.group;
      accentColor = stateColors.primary;
      updateElevation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: group.id,
      child: SizedBox(
        width: 240.0,
        height: 240.0,
        child: Card(
          elevation: 6.0,
          child: InkWell(
            onTap: onNavigateToGroupPage,
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
                    onPressed: () async {
                      final isOn = group.action.on;

                      final action = GroupAction((g) => g..on = !isOn);

                      await userState.bridge.updateGroupState(
                          group.rebuild((g) => g..action = action.toBuilder()));

                      fetch();
                    },
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

  void onNavigateToGroupPage() async {
    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent, // onTap doesn't work without this
              child: Hero(
                tag: group.id,
                child: Center(
                  child: Container(
                    width: 800,
                    padding: const EdgeInsets.all(80.0),
                    child: Card(
                      elevation: 8.0,
                      child: GestureDetector(
                        onTap: () {}, // to block parent onTap()
                        child: GroupPage(
                          group: group,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ));

    fetch();
  }

  /// Fetch a single light's data.
  void fetch() async {
    if (isLoading && timerUpdate != null) {
      timerUpdate.cancel();
    }

    isLoading = true;

    timerUpdate = Timer(150.milliseconds, () async {
      try {
        final newSensor = await userState.bridge.group(group.id);

        if (!mounted) {
          return;
        }

        setState(() {
          isLoading = false;
          group = newSensor;
          updateElevation();
        });
      } catch (error) {
        debugPrint(error.toString());
        setState(() => isLoading = false);
      }
    });
  }

  void updateElevation() {
    elevation = group.action.on ? 6.0 : 0.0;
  }
}
