import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/router/app_router.gr.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/constants.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final titleStyle = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w400,
  );

  final paragraphStyle = TextStyle(
    fontSize: 18.0,
    height: 1.5,
  );

  final titleOpacity = 0.9;
  final paragraphOpacity = 0.6;
  final captionOpacity = 0.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            onTapIconHeader: () => context.router.navigate(HomeRoute()),
          ),
          header(),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 150.0,
        bottom: 300.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              thePurpose(),
              theDevStack(),
              thePerson(),
            ],
          ),
        ]),
      ),
    );
  }

  Widget header() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(
            90.0,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  onPressed: context.router.pop,
                  icon: Icon(UniconsLine.arrow_left),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Text(Constants.appVersion),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget thePurpose() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Opacity(
              opacity: titleOpacity,
              child: Text(
                'THE PURPOSE',
                style: titleStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "lumi is an app to quickly control Philips Hue lights and sensors. If you often want to adjust these devices without taking your phone, this is made for you. The features are pretty basic for now but more will come later.",
                style: paragraphStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget theDevStack() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Opacity(
              opacity: titleOpacity,
              child: Text(
                'DEV STACK',
                style: titleStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "This app has been crafted by code with Flutter.",
                style: paragraphStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "If you want to learn how the technology behind this app, visit the GitHub repository. or stay tuned for future blog posts explanations.",
                style: paragraphStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: ElevatedButton.icon(
              onPressed: () => launch('https://github.com/rootasjey/lumi'),
              style: ElevatedButton.styleFrom(
                primary: stateColors.primary,
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              icon: Icon(LineAwesomeIcons.github, color: Colors.black54),
              label: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Github',
                  style: FontsUtils.mainStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget thePerson() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Opacity(
              opacity: titleOpacity,
              child: Text(
                'ME',
                style: titleStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "I'm a french freelance developer.",
                style: paragraphStyle,
              ),
            ),
          ),
          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                "You can find more of me and my work on my website.",
                style: paragraphStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: ElevatedButton.icon(
              onPressed: () => launch('https://rootasjey.dev'),
              style: ElevatedButton.styleFrom(
                primary: stateColors.primary,
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              icon: Icon(LineAwesomeIcons.box_open, color: Colors.black54),
              label: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'rootasjey.dev',
                  style: FontsUtils.mainStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
