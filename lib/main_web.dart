import 'package:flutter/material.dart';
import 'package:lumi/screens/home.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/app_localstorage.dart';
import 'package:lumi/utils/brightness.dart';
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
      home: Home(),
    );
  }

  void loadBrightness() {
    final autoBrightness = appLocalStorage.getAutoBrightness();

    if (!autoBrightness) {
      final brightness = appLocalStorage.getBrightness();

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