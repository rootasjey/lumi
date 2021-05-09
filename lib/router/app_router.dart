import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:lumi/router/auth_guard.dart';
import 'package:lumi/router/no_auth_guard.dart';
import 'package:lumi/screens/about.dart';
import 'package:lumi/screens/app_presentation.dart';
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
  AutoRoute(
    path: '/presentation',
    page: AppPresentation,
    guards: [NoAuthGuard],
  ),
  MaterialRoute(path: '/about', page: About),
  AutoRoute(
    path: '/connect',
    page: ConnectPage,
    guards: [NoAuthGuard],
  ),
  MaterialRoute(path: '/tos', page: Tos),
  MaterialRoute(path: '*', page: UndefinedPage),
])
class $AppRouter {}
