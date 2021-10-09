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
  static const String groupsRoute = '/home/groups';

  @override
  List get pathBlueprints => [
        route,
        lightsRoute,
        sensorsRoute,
        groupsRoute,
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
          child: LightPage(lightId: state.pathParameters['lightId']),
          key: ValueKey('sensors/${state.pathParameters['lightId']}'),
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
      if (state.pathBlueprintSegments.contains('groups'))
        BeamPage(
          child: GroupsPage(),
          key: ValueKey(groupsRoute),
          title: "Groups",
          type: BeamPageType.fadeTransition,
        ),
      if (state.pathBlueprintSegments.contains(':groupId'))
        BeamPage(
          child: GroupPage(groupId: state.pathParameters['groupId']),
          key: ValueKey('groups/${state.pathParameters['groupId']}'),
          title: "Group",
          type: BeamPageType.fadeTransition,
        ),
    ];
  }
}
