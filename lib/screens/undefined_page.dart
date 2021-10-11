import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lumi/components/app_icon.dart';
import 'package:lumi/router/locations/home_location.dart';

class UndefinedPage extends StatefulWidget {
  UndefinedPage();

  @override
  _UndefinedPageState createState() => _UndefinedPageState();
}

class _UndefinedPageState extends State<UndefinedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              header(),
              body(),
              footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 600.0,
            child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Column(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          "It's dark in there. "
                          "Follow the light to go back on track",
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Widget footer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextButton(
            onPressed: () {
              Beamer.of(context).beamToNamed(HomeLocation.route);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Go home'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 300.0),
        ),
      ],
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80.0,
        bottom: 60.0,
      ),
      child: Column(
        children: [
          AppIcon(),
          Text(
            '404',
            style: TextStyle(
              fontSize: 80.0,
            ),
          ),
          Opacity(
            opacity: .6,
            child: Text(
                'Route for "${Beamer.of(context).currentBeamLocation.pathBlueprints.join('/')}" is not defined.'),
          ),
        ],
      ),
    );
  }
}
