// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../screens/about.dart' as _i6;
import '../screens/app_presentation.dart' as _i5;
import '../screens/connection.dart' as _i7;
import '../screens/home.dart' as _i10;
import '../screens/tos.dart' as _i8;
import '../screens/undefined_page.dart' as _i9;
import 'auth_guard.dart' as _i4;
import 'no_auth_guard.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter({@_i2.required this.noAuthGuard, @_i2.required this.authGuard})
      : assert(noAuthGuard != null),
        assert(authGuard != null);

  final _i3.NoAuthGuard noAuthGuard;

  final _i4.AuthGuard authGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    AppPresentationRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i5.AppPresentation());
    },
    AboutRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i6.About());
    },
    ConnectionRoute.name: (entry) {
      var route = entry.routeData.as<ConnectionRoute>();
      return _i1.MaterialPageX(
          entry: entry,
          child: _i7.Connection(
              key: route.key, onSigninResult: route.onSigninResult));
    },
    DashboardPage.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    TosRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i8.Tos());
    },
    UndefinedPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i9.UndefinedPage());
    },
    HomeRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i10.Home());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig<AppPresentationRoute>(AppPresentationRoute.name,
            path: '/',
            routeBuilder: (match) => AppPresentationRoute.fromMatch(match)),
        _i1.RouteConfig<AboutRoute>(AboutRoute.name,
            path: '/about',
            routeBuilder: (match) => AboutRoute.fromMatch(match)),
        _i1.RouteConfig<ConnectionRoute>(ConnectionRoute.name,
            path: '/connection',
            routeBuilder: (match) => ConnectionRoute.fromMatch(match),
            guards: [noAuthGuard]),
        _i1.RouteConfig<DashboardPage>(DashboardPage.name,
            path: '/dashboard',
            routeBuilder: (match) => DashboardPage.fromMatch(match),
            guards: [
              authGuard
            ],
            children: [
              _i1.RouteConfig<HomeRoute>(HomeRoute.name,
                  path: 'lights',
                  routeBuilder: (match) => HomeRoute.fromMatch(match))
            ]),
        _i1.RouteConfig<TosRoute>(TosRoute.name,
            path: '/tos', routeBuilder: (match) => TosRoute.fromMatch(match)),
        _i1.RouteConfig<UndefinedPageRoute>(UndefinedPageRoute.name,
            path: '*',
            routeBuilder: (match) => UndefinedPageRoute.fromMatch(match))
      ];
}

class AppPresentationRoute extends _i1.PageRouteInfo {
  const AppPresentationRoute() : super(name, path: '/');

  AppPresentationRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'AppPresentationRoute';
}

class AboutRoute extends _i1.PageRouteInfo {
  const AboutRoute() : super(name, path: '/about');

  AboutRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'AboutRoute';
}

class ConnectionRoute extends _i1.PageRouteInfo {
  ConnectionRoute({this.key, this.onSigninResult})
      : super(name, path: '/connection');

  ConnectionRoute.fromMatch(_i1.RouteMatch match)
      : key = null,
        onSigninResult = null,
        super.fromMatch(match);

  final _i2.Key key;

  final void Function(bool) onSigninResult;

  static const String name = 'ConnectionRoute';
}

class DashboardPage extends _i1.PageRouteInfo {
  const DashboardPage({List<_i1.PageRouteInfo> children})
      : super(name, path: '/dashboard', initialChildren: children);

  DashboardPage.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'DashboardPage';
}

class TosRoute extends _i1.PageRouteInfo {
  const TosRoute() : super(name, path: '/tos');

  TosRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'TosRoute';
}

class UndefinedPageRoute extends _i1.PageRouteInfo {
  const UndefinedPageRoute() : super(name, path: '*');

  UndefinedPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'UndefinedPageRoute';
}

class HomeRoute extends _i1.PageRouteInfo {
  const HomeRoute() : super(name, path: 'lights');

  HomeRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'HomeRoute';
}
