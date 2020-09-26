import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_dart/hue_dart.dart' hide Timer;
import 'package:lumi/components/error_view.dart';
import 'package:lumi/components/light_card.dart';
import 'package:lumi/components/loading_view.dart';
import 'package:lumi/state/user_state.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {
  List<Light> lights = [];
  Exception error;

  bool isLoading = false;

  Timer updateBrightnessTimer;

  final sliderValues = Map<int, double>();

  @override
  void initState() {
    super.initState();
    fetch(showLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SliverList(
        delegate: SliverChildListDelegate([
          LoadingView(),
        ]),
      );
    }

    if (error != null && lights.length == 0) {
      return SliverList(
        delegate: SliverChildListDelegate([
          ErrorView(),
        ]),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300.0,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final light = lights[index];
          return LightCard(light: light);
        },
        childCount: lights.length,
      ),
    );
  }

  /// Fetch all lights' data.
  void fetch({showLoading = false}) async {
    if (showLoading) {
      setState(() => isLoading = true);
    }

    try {
      lights = await userState.bridge.lights();

      final title = '${lights.length} ${lights.length > 0 ? 'lights' : 'light'}';
      userState.setHomeSectionTitle(title);

      lights.forEach((light) {
        sliderValues[light.id] = light.state.brightness.toDouble();
      });

      setState(() {
        isLoading = false;
      });

    } on Exception catch (err) {
      setState(() {
        error = err;
        isLoading = false;
      });

      debugPrint(error.toString());
    }
  }
}
