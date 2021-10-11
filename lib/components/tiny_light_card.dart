import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/router/navigation_state_helper.dart';
import 'package:lumi/screens/home/light_page.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class TinyLightCard extends StatefulWidget {
  final String id;

  TinyLightCard({@required this.id});

  @override
  _TinyLightCardState createState() => _TinyLightCardState();
}

class _TinyLightCardState extends State<TinyLightCard> {
  bool isLoading = false;
  Color accentColor;

  double elevation;
  Light light;

  Timer timerUpdate;

  @override
  void initState() {
    super.initState();

    setState(() {
      accentColor = stateColors.primary;
    });

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Card(
        elevation: elevation,
        child: InkWell(
          onTap: () => onNavigateToLightPage(light),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline),
              Opacity(
                opacity: 0.6,
                child: Text(
                  widget.id,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onNavigateToLightPage(Light light) async {
    NavigationStateHelper.light = light;

    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent, // onTap doesn't work without this
              child: Center(
                child: Container(
                  width: 800,
                  padding: const EdgeInsets.all(80.0),
                  child: Card(
                    elevation: 8.0,
                    child: GestureDetector(
                      onTap: () {}, // to block parent onTap()
                      child: LightPage(
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ));

    fetch();
  }

  /// Fetch a single light's data.
  void fetch() async {
    if (isLoading && timerUpdate != null) {
      timerUpdate.cancel();
    }

    isLoading = true;

    timerUpdate = Timer(150.milliseconds, () async {
      try {
        light = await userState.bridge.light(widget.id.toInt());

        if (!mounted) {
          return;
        }

        var color = accentColor;

        if (light.state.on && light.state.hue != null) {
          final hsl = HSLColor.fromAHSL(
            1.0,
            light.state.hue / 65535 * 360,
            light.state.saturation / 255,
            light.state.brightness / 255,
          );

          color = hsl.toColor();

          if (color.red < 100 && color.green < 100 && color.blue < 100) {
            color = Color.fromARGB(
              color.alpha,
              color.red + 100,
              color.green + 100,
              color.blue + 100,
            );
          }
        }

        setState(() {
          isLoading = false;
          accentColor = color;
          updateElevation();
        });
      } catch (error) {
        debugPrint(error.toString());
        isLoading = false;
        setState(() {});
      }
    });
  }

  void updateElevation() {
    elevation = light.state.on ? 6.0 : 0.0;
  }
}
