import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:lumi/router/auth_guard.dart';
import 'package:lumi/router/no_auth_guard.dart';
import 'package:lumi/screens/about.dart';
import 'package:lumi/screens/app_presentation.dart';
import 'package:lumi/screens/connection.dart';
import 'package:lumi/screens/home.dart';
import 'package:lumi/screens/tos.dart';
import 'package:lumi/screens/undefined_page.dart';

@MaterialAutoRouter(routes: [
  AutoRoute(path: '/', page: AppPresentation, guards: [NoAuthGuard]),
  MaterialRoute(path: '/about', page: About),
  AutoRoute(path: '/connection', page: Connection, guards: [NoAuthGuard]),
  AutoRoute(
    path: '/dashboard',
    page: EmptyRouterPage,
    name: 'DashboardPage',
    guards: [AuthGuard],
    children: [
      MaterialRoute(path: 'lights', page: Home),
    ],
  ),
  MaterialRoute(path: '/tos', page: Tos),
  MaterialRoute(path: '*', page: UndefinedPage),
])
class $AppRouter {}
