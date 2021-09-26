import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/constants.dart';

class BrightnessUtils {
  static Brightness currentBrightness = Brightness.dark;

  static void refreshBrightness() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    final brightness =
        savedThemeMode.isDark ? Brightness.dark : Brightness.light;

    currentBrightness = brightness;
  }

  /// Refresh current theme with auto brightness.
  static void setAutoBrightness(BuildContext context) async {
    final now = DateTime.now();

    Brightness brightness = Brightness.light;

    if (now.hour < 6 || now.hour > 17) {
      brightness = Brightness.dark;
    }

    if (brightness == Brightness.dark) {
      AdaptiveTheme.of(context).setDark();
      currentBrightness = Brightness.dark;
    } else {
      AdaptiveTheme.of(context).setLight();
      currentBrightness = Brightness.light;
    }

    stateColors.refreshTheme(brightness: brightness);
    Glutton.eat(KEY_AUTO_BRIGHTNESS, true);
  }

  /// Refresh current theme with a specific brightness.
  static void setBrightness(BuildContext context, Brightness brightness) {
    if (brightness == Brightness.dark) {
      AdaptiveTheme.of(context).setDark();
      currentBrightness = Brightness.dark;
    } else {
      AdaptiveTheme.of(context).setLight();
      currentBrightness = Brightness.light;
    }

    stateColors.refreshTheme(brightness: brightness);
    Glutton.eat(KEY_AUTO_BRIGHTNESS, false);
  }
}
