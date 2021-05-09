// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'dart:ui' as _i20;

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;
import 'package:hue_api/hue_dart.dart' as _i19;

import '../screens/about_page.dart' as _i6;
import '../screens/app_presentation.dart' as _i7;
import '../screens/config_page.dart' as _i17;
import '../screens/connect_page.dart' as _i8;
import '../screens/home.dart' as _i5;
import '../screens/home/group_page.dart' as _i12;
import '../screens/home/groups_page.dart' as _i11;
import '../screens/home/light_page.dart' as _i14;
import '../screens/home/lights_page.dart' as _i13;
import '../screens/home/sensor_page.dart' as _i16;
import '../screens/home/sensors_page.dart' as _i15;
import '../screens/tos.dart' as _i9;
import '../screens/undefined_page.dart' as _i10;
import '../screens/users_page.dart' as _i18;
import 'auth_guard.dart' as _i3;
import 'no_auth_guard.dart' as _i4;

class AppRouter extends _i1.RootStackRouter {
  AppRouter({@_i2.required this.authGuard, @_i2.required this.noAuthGuard})
      : assert(authGuard != null),
        assert(noAuthGuard != null);

  final _i3.AuthGuard authGuard;

  final _i4.NoAuthGuard noAuthGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomeRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i5.Home());
    },
    AboutPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i6.AboutPage());
    },
    AppPresentationRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i7.AppPresentation());
    },
    ConnectPageRoute.name: (entry) {
      var route = entry.routeData.as<ConnectPageRoute>();
      return _i1.MaterialPageX(
          entry: entry,
          child: _i8.ConnectPage(
              key: route.key, onSigninResult: route.onSigninResult));
    },
    SettingsRouter.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    TosRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i9.Tos());
    },
    UndefinedPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i10.UndefinedPage());
    },
    GroupsRouter.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    LightsRouter.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    SensorsRouter.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    GroupsPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i11.GroupsPage());
    },
    GroupPageRoute.name: (entry) {
      var route = entry.routeData.as<GroupPageRoute>();
      return _i1.MaterialPageX(
          entry: entry,
          child: _i12.GroupPage(group: route.group, groupId: route.groupId));
    },
    LightsPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i13.LightsPage());
    },
    LightPageRoute.name: (entry) {
      var route = entry.routeData.as<LightPageRoute>();
      return _i1.MaterialPageX(
          entry: entry,
          child: _i14.LightPage(
              light: route.light, lightId: route.lightId, color: route.color));
    },
    SensorsPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i15.SensorsPage());
    },
    SensorPageRoute.name: (entry) {
      var route = entry.routeData.as<SensorPageRoute>();
      return _i1.MaterialPageX(
          entry: entry,
          child:
              _i16.SensorPage(sensor: route.sensor, sensorId: route.sensorId));
    },
    ConfigPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i17.ConfigPage());
    },
    UsersPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i18.UsersPage());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig<HomeRoute>(HomeRoute.name,
            path: '/',
            usesTabsRouter: true,
            routeBuilder: (match) => HomeRoute.fromMatch(match),
            guards: [
              authGuard
            ],
            children: [
              _i1.RouteConfig<GroupsRouter>(GroupsRouter.name,
                  path: 'groups',
                  routeBuilder: (match) => GroupsRouter.fromMatch(match),
                  children: [
                    _i1.RouteConfig<GroupsPageRoute>(GroupsPageRoute.name,
                        path: '',
                        routeBuilder: (match) =>
                            GroupsPageRoute.fromMatch(match)),
                    _i1.RouteConfig<GroupPageRoute>(GroupPageRoute.name,
                        path: ':groupId',
                        routeBuilder: (match) =>
                            GroupPageRoute.fromMatch(match)),
                    _i1.RouteConfig('*#redirect',
                        path: '*', redirectTo: '', fullMatch: true)
                  ]),
              _i1.RouteConfig<LightsRouter>(LightsRouter.name,
                  path: 'lights',
                  routeBuilder: (match) => LightsRouter.fromMatch(match),
                  children: [
                    _i1.RouteConfig<LightsPageRoute>(LightsPageRoute.name,
                        path: '',
                        routeBuilder: (match) =>
                            LightsPageRoute.fromMatch(match)),
                    _i1.RouteConfig<LightPageRoute>(LightPageRoute.name,
                        path: ':lightId',
                        routeBuilder: (match) =>
                            LightPageRoute.fromMatch(match)),
                    _i1.RouteConfig('*#redirect',
                        path: '*', redirectTo: '', fullMatch: true)
                  ]),
              _i1.RouteConfig<SensorsRouter>(SensorsRouter.name,
                  path: 'sensors',
                  routeBuilder: (match) => SensorsRouter.fromMatch(match),
                  children: [
                    _i1.RouteConfig<SensorsPageRoute>(SensorsPageRoute.name,
                        path: '',
                        routeBuilder: (match) =>
                            SensorsPageRoute.fromMatch(match)),
                    _i1.RouteConfig<SensorPageRoute>(SensorPageRoute.name,
                        path: ':sensorId',
                        routeBuilder: (match) =>
                            SensorPageRoute.fromMatch(match)),
                    _i1.RouteConfig('*#redirect',
                        path: '*', redirectTo: '', fullMatch: true)
                  ])
            ]),
        _i1.RouteConfig<AboutPageRoute>(AboutPageRoute.name,
            path: '/about',
            routeBuilder: (match) => AboutPageRoute.fromMatch(match)),
        _i1.RouteConfig<AppPresentationRoute>(AppPresentationRoute.name,
            path: '/presentation',
            routeBuilder: (match) => AppPresentationRoute.fromMatch(match),
            guards: [noAuthGuard]),
        _i1.RouteConfig<ConnectPageRoute>(ConnectPageRoute.name,
            path: '/connect',
            routeBuilder: (match) => ConnectPageRoute.fromMatch(match),
            guards: [noAuthGuard]),
        _i1.RouteConfig<SettingsRouter>(SettingsRouter.name,
            path: '/settings',
            routeBuilder: (match) => SettingsRouter.fromMatch(match),
            guards: [
              authGuard
            ],
            children: [
              _i1.RouteConfig<ConfigPageRoute>(ConfigPageRoute.name,
                  path: '',
                  routeBuilder: (match) => ConfigPageRoute.fromMatch(match)),
              _i1.RouteConfig<UsersPageRoute>(UsersPageRoute.name,
                  path: 'users',
                  routeBuilder: (match) => UsersPageRoute.fromMatch(match)),
              _i1.RouteConfig('*#redirect',
                  path: '*', redirectTo: '', fullMatch: true)
            ]),
        _i1.RouteConfig<TosRoute>(TosRoute.name,
            path: '/tos', routeBuilder: (match) => TosRoute.fromMatch(match)),
        _i1.RouteConfig<UndefinedPageRoute>(UndefinedPageRoute.name,
            path: '*',
            routeBuilder: (match) => UndefinedPageRoute.fromMatch(match))
      ];
}

class HomeRoute extends _i1.PageRouteInfo {
  const HomeRoute({List<_i1.PageRouteInfo> children})
      : super(name, path: '/', initialChildren: children);

  HomeRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'HomeRoute';
}

class AboutPageRoute extends _i1.PageRouteInfo {
  const AboutPageRoute() : super(name, path: '/about');

  AboutPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'AboutPageRoute';
}

class AppPresentationRoute extends _i1.PageRouteInfo {
  const AppPresentationRoute() : super(name, path: '/presentation');

  AppPresentationRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'AppPresentationRoute';
}

class ConnectPageRoute extends _i1.PageRouteInfo {
  ConnectPageRoute({this.key, this.onSigninResult})
      : super(name, path: '/connect');

  ConnectPageRoute.fromMatch(_i1.RouteMatch match)
      : key = null,
        onSigninResult = null,
        super.fromMatch(match);

  final _i2.Key key;

  final void Function(bool) onSigninResult;

  static const String name = 'ConnectPageRoute';
}

class SettingsRouter extends _i1.PageRouteInfo {
  const SettingsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: '/settings', initialChildren: children);

  SettingsRouter.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'SettingsRouter';
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

class GroupsRouter extends _i1.PageRouteInfo {
  const GroupsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: 'groups', initialChildren: children);

  GroupsRouter.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'GroupsRouter';
}

class LightsRouter extends _i1.PageRouteInfo {
  const LightsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: 'lights', initialChildren: children);

  LightsRouter.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'LightsRouter';
}

class SensorsRouter extends _i1.PageRouteInfo {
  const SensorsRouter({List<_i1.PageRouteInfo> children})
      : super(name, path: 'sensors', initialChildren: children);

  SensorsRouter.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'SensorsRouter';
}

class GroupsPageRoute extends _i1.PageRouteInfo {
  const GroupsPageRoute() : super(name, path: '');

  GroupsPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'GroupsPageRoute';
}

class GroupPageRoute extends _i1.PageRouteInfo {
  GroupPageRoute({this.group, this.groupId})
      : super(name, path: ':groupId', params: {'groupId': groupId});

  GroupPageRoute.fromMatch(_i1.RouteMatch match)
      : group = null,
        groupId = match.pathParams.getString('groupId'),
        super.fromMatch(match);

  final _i19.Group group;

  final String groupId;

  static const String name = 'GroupPageRoute';
}

class LightsPageRoute extends _i1.PageRouteInfo {
  const LightsPageRoute() : super(name, path: '');

  LightsPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'LightsPageRoute';
}

class LightPageRoute extends _i1.PageRouteInfo {
  LightPageRoute({this.light, this.lightId, this.color})
      : super(name, path: ':lightId', params: {'lightId': lightId});

  LightPageRoute.fromMatch(_i1.RouteMatch match)
      : light = null,
        lightId = match.pathParams.getString('lightId'),
        color = null,
        super.fromMatch(match);

  final _i19.Light light;

  final String lightId;

  final _i20.Color color;

  static const String name = 'LightPageRoute';
}

class SensorsPageRoute extends _i1.PageRouteInfo {
  const SensorsPageRoute() : super(name, path: '');

  SensorsPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'SensorsPageRoute';
}

class SensorPageRoute extends _i1.PageRouteInfo {
  SensorPageRoute({this.sensor, this.sensorId})
      : super(name, path: ':sensorId', params: {'sensorId': sensorId});

  SensorPageRoute.fromMatch(_i1.RouteMatch match)
      : sensor = null,
        sensorId = match.pathParams.getString('sensorId'),
        super.fromMatch(match);

  final _i19.Sensor sensor;

  final String sensorId;

  static const String name = 'SensorPageRoute';
}

class ConfigPageRoute extends _i1.PageRouteInfo {
  const ConfigPageRoute() : super(name, path: '');

  ConfigPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'ConfigPageRoute';
}

class UsersPageRoute extends _i1.PageRouteInfo {
  const UsersPageRoute() : super(name, path: 'users');

  UsersPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'UsersPageRoute';
}
