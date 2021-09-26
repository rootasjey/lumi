import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lumi/components/home_side_menu.dart';
import 'package:lumi/router/locations/home_location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _beamerKey = GlobalKey<BeamerState>();

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope(
      controller: HeroController(),
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Beamer(
                key: _beamerKey,
                routerDelegate: BeamerDelegate(
                  locationBuilder: (state) => HomeContentLocation(state),
                ),
              ),
            ),
            HomeSideMenu(
              beamerKey: _beamerKey,
            ),
          ],
        ),
      ),
    );
  }
}
