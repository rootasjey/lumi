import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/screens/connection.dart';
import 'package:lumi/screens/home/lights.dart';
import 'package:lumi/screens/home/groups.dart';
import 'package:lumi/screens/home/sensors.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scrollController = ScrollController();

  /// Selected tab (sensors, lights, scenes, ...).
  int selectedIndex = 0;

  final childrenBody = [
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
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          appBar(),
          navigation(),
          title(),
          body(),
        ],
      ),
    );
  }

  Widget appBar() {
    return HomeAppBar(
      title: Text(
        'lumi',
        style: TextStyle(
          fontSize: 50.0,
        ),
      ),
      onTapIconHeader: () {
        scrollController.animateTo(
          0,
          duration: 250.milliseconds,
          curve: Curves.decelerate,
        );
      },
    );
  }

  Widget navigation() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          height: 100.0,
          padding: const EdgeInsets.only(
            top: 60.0,
            left: 100.0,
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              navButton(
                title: 'LIGHTS',
                index: 0,
              ),
              navButton(
                title: 'SENSORS',
                index: 1,
              ),
              navButton(
                title: 'SCENES',
                index: 2,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget navButton({
    String title,
    int index = 0,
  }) {
    Widget childButton;

    if (index != selectedIndex) {
      childButton = TextButton(
        onPressed: () => setState(() => selectedIndex = index),
        child: Opacity(
          opacity: 0.6,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    } else {
      childButton = ElevatedButton(
        onPressed: () => setState(() => selectedIndex = index),
        style: ElevatedButton.styleFrom(
          primary: stateColors.primary,
          textStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: childButton,
    );
  }

  Widget body() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 100.0,
        vertical: 80.0,
      ),
      sliver: childrenBody[selectedIndex],
    );
  }

  Widget title() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 40.0,
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
                  style: TextStyle(
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
}
