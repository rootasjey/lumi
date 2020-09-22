import 'package:flutter/material.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  List<Group> groups = [];
  Exception error;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGroups(showLoading: true);
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
          return groupCard(group);
        },
        childCount: groups.length,
      ),
    );
  }

  Widget groupCard(Group group) {
    return SizedBox(
      width: 240.0,
      height: 240.0,
      child: Card(
        elevation: 6.0,
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

                  final action = GroupAction(
                    (g) => g..on = !isOn
                  );

                  await userState.bridge.updateGroupState(
                    group.rebuild(
                      (g) => g..action = action.toBuilder()
                    )
                  );

                  fetchGroups();
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
    );
  }

  void fetchGroups({showLoading = false}) async {
    if (showLoading) {
      setState(() => isLoading = true);
    }

    try {
      final groupsItems = await userState.bridge.groups();

      final title = '${groupsItems.length} ${groupsItems.length > 0 ? 'scenes' : 'scene'}';
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
}
