import 'package:beamer/beamer.dart';
import 'package:lumi/router/locations/about_location.dart';
import 'package:lumi/router/locations/connect_location.dart';
import 'package:lumi/router/locations/home_location.dart';
import 'package:lumi/router/locations/settings_location.dart';
import 'package:lumi/router/locations/tos_location.dart';
import 'package:lumi/router/locations/undefined_location.dart';

final appRouterDelegate = BeamerDelegate(
  initialPath: '/home',
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      HomeLocation(),
      ConnectLocation(),
      AboutLocation(),
      SettingsLocation(),
      TosLocation(),
    ],
  ),
  notFoundRedirect: UndefinedLocation(),
);
