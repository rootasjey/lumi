import 'package:flutter/material.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:supercharged/supercharged.dart';

class LightPage extends StatefulWidget {
  final String id;
  final Light light;

  LightPage({
    this.id,
    this.light,
  });

  @override
  _LightPageState createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  Light light;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      light = widget.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          header(),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 40.0,
      ),
      child: Wrap(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 16.0,
            ),
            child: Icon(
              Icons.lightbulb_outline,
              size: 40.0,
              color: light.state.on
                ? stateColors.primary
                : stateColors.foreground.withOpacity(0.6),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Text(
              light.name,
              style: TextStyle(
                fontSize: 50.0,
              )
            ),
          ),
        ],
      ),
    );
  }

  void fetch() async {
    setState(() => isLoading = true);

    try {
      light = await userState.bridge.light(widget.id.toInt());

      setState(() => isLoading = false);

    } catch (error) {
      debugPrint(error.toString());
      setState(() => isLoading = false);
    }
  }
}
