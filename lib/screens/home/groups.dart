import 'package:flutter/material.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/group_card.dart';
import 'package:lumi/components/loading_view.dart';
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
          return GroupCard(group: group);
        },
        childCount: groups.length,
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
