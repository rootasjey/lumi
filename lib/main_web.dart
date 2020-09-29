import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lumi/screens/connection.dart';
import 'package:lumi/screens/home.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/brightness.dart';
import 'package:lumi/utils/constants.dart';
import 'package:supercharged/supercharged.dart';

class MainWeb extends StatefulWidget {
  @override
  _MainWebState createState() => _MainWebState();
}

class _MainWebState extends State<MainWeb> {
  @override
  initState() {
    super.initState();
    loadBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lumi',
      theme: stateColors.themeData,
      debugShowCheckedModeBanner: false,
      home: userState.isUserConnected
        ? Home()
        : Connection(),
    );
  }

  void loadBrightness() {
    bool autoBrightness = Hive.box(KEY_SETTINGS).get(KEY_AUTO_BRIGHTNESS);

    if (!autoBrightness) {
      bool darkMode = Hive.box(KEY_SETTINGS).get(KEY_DARK_MODE);

      final brightness = darkMode
        ? Brightness.dark
        : Brightness.light;

      setBrightness(
        brightness: brightness,
        context: context,
        duration: 250.milliseconds,
      );

      return;
    }

    setAutoBrightness(context: context, duration: 2.seconds);
  }
}