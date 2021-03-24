import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:lumi/state/colors.dart';

class BrightnessUtils {
  /// Refresh current theme with auto brightness.
  static void setAutoBrightness(BuildContext context) async {
    final now = DateTime.now();

    Brightness brightness = Brightness.light;

    if (now.hour < 6 || now.hour > 17) {
      brightness = Brightness.dark;
    }

    if (brightness == Brightness.dark) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }

    stateColors.refreshTheme(brightness: brightness);
    // appStorage.setAutoBrightness(true);
    // final box = await Hive.openBox(KEY_SETTINGS);
    // box.get(KEY_AUTO_BRIGHTNESS)
  }

  /// Refresh current theme with a specific brightness.
  static void setBrightness(BuildContext context, Brightness brightness) {
    if (brightness == Brightness.dark) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }

    stateColors.refreshTheme(brightness: brightness);
    // appStorage.setAutoBrightness(false);
    // appStorage.setBrightness(brightness);
  }
}
