import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/group_card.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/screens/home/group_page.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  List<Group> groups = [];
  Exception error;

  bool isLoading = false;

  Timer pageUpdateTimer;

  @override
  void initState() {
    super.initState();
    fetchGroups(showLoading: true);
    startPolling();
  }

  @override
  dispose() {
    pageUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SliverList(
        delegate: SliverChildListDelegate([
          LoadingView(),
        ]),
      );
    }

    if (error != null && groups.length == 0) {
      return SliverList(
        delegate: SliverChildListDelegate([
          ErrorView(),
        ]),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300.0,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final group = groups[index];
          return GroupCard(
              key: Key(group.uniqueId),
              group: group,
              onToggle: () async {
                final isOn = group.action.on;

                final action = GroupAction((g) => g..on = !isOn);

                await userState.bridge.updateGroupState(
                    group.rebuild((g) => g..action = action.toBuilder()));

                fetchGroups();
              },
              onTap: () {
                onTap(group);
              });
        },
        childCount: groups.length,
      ),
    );
  }

  void startPolling() async {
    pageUpdateTimer = Timer.periodic(
      2.seconds,
      (timer) {
        fetchGroups(showLoading: false);
      },
    );
  }

  void fetchGroups({showLoading = false}) async {
    if (showLoading) {
      setState(() => isLoading = true);
    }

    try {
      final groupsItems = await userState.bridge.groups();

      final title =
          '${groupsItems.length} ${groupsItems.length > 0 ? 'scenes' : 'scene'}';

      userState.setHomeSectionTitle(title);

      setState(() {
        groups = groupsItems;
        isLoading = false;
      });
    } on Exception catch (err) {
      setState(() {
        error = err;
        isLoading = false;
      });

      debugPrint(error.toString());
    }
  }

  void onTap(Group group) async {
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

    fetchGroups();
  }
}
