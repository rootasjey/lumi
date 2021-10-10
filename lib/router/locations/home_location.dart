import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:lumi/router/locations/connect_location.dart';
import 'package:lumi/screens/home/group_page.dart';
import 'package:lumi/screens/home/groups_page.dart';
import 'package:lumi/screens/home/light_page.dart';
import 'package:lumi/screens/home/lights_page.dart';
import 'package:lumi/screens/home/sensor_page.dart';
import 'package:lumi/screens/home/sensors_page.dart';
import 'package:lumi/screens/home_page.dart';
import 'package:lumi/state/user_state.dart';

class HomeLocation extends BeamLocation {
  static const String route = '/home/*';

  @override
  List get pathBlueprints => [route];

  @override
  List<BeamGuard> get guards => [
        BeamGuard(
          pathBlueprints: [route],
          check: (context, state) => userState.isUserConnected,
          beamToNamed: ConnectLocation.route,
        ),
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: HomePage(),
        key: ValueKey(route),
        title: 'Home',
        type: BeamPageType.fadeTransition,
      )
    ];
  }
}

class HomeContentLocation extends BeamLocation {
  HomeContentLocation(BeamState state) : super(state);

  static const String route = '/home';
  static const String lightsRoute = '/home/lights';
  static const String sensorsRoute = '/home/sensors';
  static const String scenesRoute = '/home/scenes';
  static const String lightRoute = '/home/lights/:lightId';
  static const String sensorRoute = '/home/sensors/:sensorId';
  static const String sceneRoute = '/home/scenes/:sceneId';

  @override
  List get pathBlueprints => [
        route,
        lightsRoute,
        sensorsRoute,
        scenesRoute,
      ];

  @override
  List<BeamGuard> get guards => [
        BeamGuard(
            pathBlueprints: [route],
            check: (context, state) => false,
            beamToNamed: lightsRoute),
      ];

  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: LightsPage(),
        key: ValueKey(route),
        title: "Lights",
        type: BeamPageType.fadeTransition,
      ),
      if (state.pathBlueprintSegments.contains('lights'))
        BeamPage(
          child: LightsPage(),
          key: ValueKey(lightsRoute),
          title: "Lights",
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathBlueprintSegments.contains(':lightId'))
        BeamPage(
          child: LightPage(lightId: int.parse(state.pathParameters['lightId'])),
          key: ValueKey('lights/${state.pathParameters['lightId']}'),
          title: "Light",
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathBlueprintSegments.contains('sensors'))
        BeamPage(
          child: SensorsPage(),
          key: ValueKey(sensorsRoute),
          title: "Sensors",
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathBlueprintSegments.contains(':sensorId'))
        BeamPage(
          child: SensorPage(sensorId: state.pathParameters['sensorId']),
          key: ValueKey('sensors/${state.pathParameters['sensorId']}'),
          title: "Sensor",
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathBlueprintSegments.contains('scenes'))
        BeamPage(
          child: GroupsPage(),
          key: ValueKey(scenesRoute),
          title: "Scenes",
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathBlueprintSegments.contains(':sceneId'))
        BeamPage(
          child: GroupPage(groupId: state.pathParameters['sceneId']),
          key: ValueKey('scenes/${state.pathParameters['sceneId']}'),
          title: "Group",
          type: BeamPageType.fadeTransition,
        ),
    ];
  }
}
