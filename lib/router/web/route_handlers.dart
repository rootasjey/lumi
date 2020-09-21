import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lumi/screens/about.dart';
import 'package:lumi/screens/home.dart';
import 'package:lumi/screens/undefined_page.dart';

class WebRouteHandlers {
  static Handler about = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      About());

  static Handler home = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      Home());

  static Handler undefined = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
      UndefinedPage(name: params['route'][0],));
}
