import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/screens/connection.dart';
import 'package:lumi/screens/home/lights.dart';
import 'package:lumi/screens/home/groups.dart';
import 'package:lumi/screens/home/sensors.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = ScrollController();

  /// Selected tab (sensors, lights, scenes, ...).
  int _selectedIndex = 0;

  final _bodyChildren = [
    Lights(),
    Sensors(),
    Groups(),
  ];

  @override
  initState() {
    super.initState();

    if (!userState.isUserConnected) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return Connection();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                appBar(),
                title(),
                body(),
              ],
            ),
          ),
          sideBar(),
        ],
      ),
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
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 100.0,
        right: 100.0,
        top: 40,
        bottom: 300.0,
      ),
      sliver: _bodyChildren[_selectedIndex],
    );
  }

  Widget title() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 100.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Observer(
            builder: (context) {
              return Opacity(
                opacity: 0.6,
                child: Text(
                  '${userState.homeSectionTitle}',
                  style: FontsUtils.titleStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }

  Widget navButton({
    String title,
    int index = 0,
    Widget icon,
  }) {
    return IconButton(
      tooltip: title,
      color: index == _selectedIndex ? stateColors.primary : null,
      onPressed: () {
        setState(() => _selectedIndex = index);
      },
      icon: Opacity(
        opacity: index == _selectedIndex ? 1.0 : 0.6,
        child: icon,
      ),
    );
  }

  Widget sideBar() {
    return Container(
      width: 80.0,
      child: Material(
        color: stateColors.appBackground,
        elevation: 6.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            navButton(
              index: 0,
              title: "Lights",
              icon: Icon(UniconsLine.lightbulb_alt),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
            ),
            navButton(
              index: 1,
              title: "Sensors",
              icon: Icon(UniconsLine.dice_one),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
            ),
            navButton(
              index: 2,
              title: "Rooms",
              icon: Icon(UniconsLine.bed_double),
            ),
          ],
        ),
      ),
    );
  }
}
