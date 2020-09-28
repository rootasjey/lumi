import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/constants.dart';

/// Refresh current theme with auto brightness.
void setAutoBrightness({
  @required BuildContext context,
  Duration duration = const Duration(seconds: 0),
}) {
  final now = DateTime.now();

  Brightness brightness = Brightness.light;

  if (now.hour < 6 || now.hour > 17) {
    brightness = Brightness.dark;
  }

  Future.delayed(
    duration,
    () async {
      try {
        DynamicTheme.of(context).setBrightness(brightness);
        stateColors.refreshTheme(brightness: brightness);
        await Hive.box(KEY_SETTINGS).put(KEY_AUTO_BRIGHTNESS, true);

      } catch (error) {
        debugPrint(error.toString());
      }
    }
  );
}

/// Refresh current theme with auto brightness.
void setBrightness({
  @required BuildContext context,
  @required Brightness brightness,
  Duration duration = const Duration(seconds: 0),
}) {

  stateColors.refreshTheme(brightness: brightness);

  Future.delayed(
    duration,
    () async {
      DynamicTheme.of(context).setBrightness(brightness);
      await Hive.box(KEY_SETTINGS).put(KEY_AUTO_BRIGHTNESS, false);

      final darkMode = brightness == Brightness.dark;
      await Hive.box(KEY_SETTINGS).put(KEY_DARK_MODE, darkMode);
    }
  );
}
