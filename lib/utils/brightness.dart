import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/app_localstorage.dart';

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
    () {
      try {
        DynamicTheme.of(context).setBrightness(brightness);
        stateColors.refreshTheme(brightness: brightness);
        appLocalStorage.setAutoBrightness(true);

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
    () {
      DynamicTheme.of(context).setBrightness(brightness);

      appLocalStorage.setAutoBrightness(false);
      appLocalStorage.setBrightness(brightness);
    }
  );
}
