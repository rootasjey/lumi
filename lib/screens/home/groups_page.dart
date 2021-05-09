import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/group_card.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/router/app_router.gr.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/app_logger.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<Group> _groups = [];
  Exception _error;

  bool _isLoading = false;

  Timer _pageUpdateTimer;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchGroups(showLoading: true);
    startPolling();
  }

  @override
  dispose() {
    _pageUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        appBar(),
        title(),
        body(),
      ],
    );
  }

  Widget appBar() {
    return HomeAppBar(
      title: Text(
        'lumi',
        style: FontsUtils.titleStyle(
          fontSize: 30.0,
        ),
      ),
      onTapIconHeader: () {
        _scrollController.animateTo(
          0,
          duration: 250.milliseconds,
          curve: Curves.decelerate,
        );
      },
    );
  }

  Widget body() {
    if (_isLoading) {
      return SliverList(
        delegate: SliverChildListDelegate([
          LoadingView(),
        ]),
      );
    }

    if (_error != null && _groups.length == 0) {
      return SliverList(
        delegate: SliverChildListDelegate([
          ErrorView(),
        ]),
      );
    }

    return gridView();
  }

  Widget gridView() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 100.0,
        right: 100.0,
        top: 40,
        bottom: 300.0,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300.0,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final group = _groups[index];
            return GroupCard(
                key: Key(group.uniqueId),
                group: group,
                elevation: group.action.on ? 6.0 : 0.0,
                onToggle: () async {
                  final isOn = group.action.on;

                  final action = GroupAction((g) => g..on = !isOn);

                  await userState.bridge.updateGroupState(
                      group.rebuild((g) => g..action = action.toBuilder()));

                  fetchGroups();
                },
                onTap: () {
                  onNavigate(group);
                });
          },
          childCount: _groups.length,
        ),
      ),
    );
  }

  Widget title() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 100.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Opacity(
            opacity: 0.6,
            child: Text(
              "groups_number".plural(_groups.length),
              style: FontsUtils.titleStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void startPolling() async {
    _pageUpdateTimer = Timer.periodic(
      2.seconds,
      (timer) {
        fetchGroups(showLoading: false);
      },
    );
  }

  void fetchGroups({showLoading = false}) async {
    if (showLoading) {
      setState(() => _isLoading = true);
    }

    try {
      final groupsItems = await userState.bridge.groups();

      setState(() {
        _groups = groupsItems;
        _isLoading = false;
      });
    } on Exception catch (err) {
      setState(() {
        _error = err;
        _isLoading = false;
      });

      appLogger.e(err);
    }
  }

  void onNavigate(Group group) async {
    context.router.push(
      GroupPageRoute(
        group: group,
        groupId: group.id.toString(),
      ),
    );
  }
}
