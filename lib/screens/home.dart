import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lumi/router/app_router.gr.dart';
import 'package:lumi/state/colors.dart';
import 'package:unicons/unicons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AutoTabsRouter(
        routes: [
          LightsRouter(),
          SensorsRouter(),
          GroupsRouter(),
        ],
        builder: (context, child, animation) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(child: child),
                sideBar(context.tabsRouter),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget navButton({
    @required String title,
    int index = 0,
    @required TabsRouter tabsRouter,
    @required Widget icon,
  }) {
    return IconButton(
      tooltip: title,
      color: index == tabsRouter.activeIndex ? stateColors.primary : null,
      onPressed: () {
        tabsRouter.setActiveIndex(index);
      },
      icon: Opacity(
        opacity: index == tabsRouter.activeIndex ? 1.0 : 0.6,
        child: icon,
      ),
    );
  }

  Widget sideBar(TabsRouter tabsRouter) {
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
              tabsRouter: tabsRouter,
              title: "lights".tr(),
              icon: Icon(UniconsLine.lightbulb_alt),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
            ),
            navButton(
              index: 1,
              tabsRouter: tabsRouter,
              title: "sensors".tr(),
              icon: Icon(UniconsLine.dice_one),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
            ),
            navButton(
              index: 2,
              tabsRouter: tabsRouter,
              title: "scenes".tr(),
              icon: Icon(UniconsLine.bed_double),
            ),
          ],
        ),
      ),
    );
  }
}
