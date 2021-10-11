import 'package:hue_api/hue_dart.dart';

class NavigationStateHelper {
  /// Last light selected.
  /// This should be affected before navigating to LightPage.
  /// This external state avoid re-fetching book's data,
  /// and make hero forward hero animation work.
  static Light light;

  /// Last sensor selected.
  /// This should be affected before navigating to SensorPage.
  /// This external state avoid re-fetching book's data,
  /// and make hero forward hero animation work.

  static Sensor sensor;

  /// Last group selected.
  /// This should be affected before navigating to GroupPage.
  /// This external state avoid re-fetching book's data,
  /// and make hero forward hero animation work.
  static Group group;
}
