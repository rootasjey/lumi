import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:lumi/router/locations/home_location.dart';
import 'package:lumi/screens/connect_page.dart';
import 'package:lumi/state/user_state.dart';

class ConnectLocation extends BeamLocation {
  /// Main root value for this location.
  static const String route = '/connect';

  @override
  List<String> get pathBlueprints => [route];

  @override
  List<BeamGuard> get guards => [
        BeamGuard(
          pathBlueprints: [route],
          check: (context, location) => !userState.isUserConnected,
          beamToNamed: HomeLocation.route,
        ),
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: ConnectPage(),
        key: ValueKey(route),
        title: "Connect",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
