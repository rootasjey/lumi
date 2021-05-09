import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:lumi/router/auth_guard.dart';
import 'package:lumi/router/no_auth_guard.dart';
import 'package:lumi/screens/about_page.dart';
import 'package:lumi/screens/app_presentation.dart';
import 'package:lumi/screens/config_page.dart';
import 'package:lumi/screens/connect_page.dart';
import 'package:lumi/screens/home.dart';
import 'package:lumi/screens/home/group_page.dart';
import 'package:lumi/screens/home/groups_page.dart';
import 'package:lumi/screens/home/light_page.dart';
import 'package:lumi/screens/home/lights_page.dart';
import 'package:lumi/screens/home/sensor_page.dart';
import 'package:lumi/screens/home/sensors_page.dart';
import 'package:lumi/screens/tos.dart';
import 'package:lumi/screens/undefined_page.dart';
import 'package:lumi/screens/users_page.dart';

@MaterialAutoRouter(routes: [
  AutoRoute(
    path: '/',
    page: Home,
    usesTabsRouter: true,
    guards: [AuthGuard],
    children: [
      AutoRoute(
        path: 'groups',
        name: 'GroupsRouter',
        page: EmptyRouterPage,
        children: [
          AutoRoute(path: '', page: GroupsPage),
          AutoRoute(path: ':groupId', page: GroupPage),
          RedirectRoute(path: '*', redirectTo: ''),
        ],
      ),
      AutoRoute(
        path: 'lights',
        name: 'LightsRouter',
        page: EmptyRouterPage,
        children: [
          AutoRoute(path: '', page: LightsPage),
          AutoRoute(path: ':lightId', page: LightPage),
          RedirectRoute(path: '*', redirectTo: ''),
        ],
      ),
      AutoRoute(
        path: 'sensors',
        name: 'SensorsRouter',
        page: EmptyRouterPage,
        children: [
          AutoRoute(path: '', page: SensorsPage),
          AutoRoute(path: ':sensorId', page: SensorPage),
          RedirectRoute(path: '*', redirectTo: ''),
        ],
      ),
    ],
  ),
  MaterialRoute(path: '/about', page: AboutPage),
  AutoRoute(
    path: '/presentation',
    page: AppPresentation,
    guards: [NoAuthGuard],
  ),
  AutoRoute(
    path: '/connect',
    page: ConnectPage,
    guards: [NoAuthGuard],
  ),
  AutoRoute(
    path: '/settings',
    name: 'SettingsRouter',
    page: EmptyRouterPage,
    guards: [AuthGuard],
    children: [
      AutoRoute(path: '', page: ConfigPage),
      AutoRoute(path: 'users', page: UsersPage),
      RedirectRoute(path: '*', redirectTo: ''),
    ],
  ),
  MaterialRoute(path: '/tos', page: Tos),
  MaterialRoute(path: '*', page: UndefinedPage),
])
class $AppRouter {}
