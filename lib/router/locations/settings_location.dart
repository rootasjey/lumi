import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:lumi/screens/settings_page.dart';
import 'package:lumi/screens/settings_users_page.dart';
import 'package:lumi/state/user_state.dart';

class SettingsLocation extends BeamLocation {
  static const String route = '/settings/*';
  static const String usersRoute = '/settings/users';

  @override
  List get pathBlueprints => [
        route,
        usersRoute,
      ];

  @override
  List<BeamGuard> get guards => [
        BeamGuard(
          pathBlueprints: [route],
          check: (context, location) => userState.isUserConnected,
        ),
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: SettingsPage(),
        key: ValueKey(route),
        title: 'Settings',
        type: BeamPageType.fadeTransition,
      ),
      if (state.pathBlueprintSegments.contains('users'))
        BeamPage(
          child: SettingsUsersPage(),
          key: ValueKey(usersRoute),
          title: 'Settings Users',
          type: BeamPageType.fadeTransition,
        ),
    ];
  }
}
