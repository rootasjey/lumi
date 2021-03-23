import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/screens/home.dart';
import 'package:lumi/state/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
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
            automaticallyImplyLeading: false,
            title: Text(
              'lumi',
              style: TextStyle(
                fontSize: 50.0,
              ),
            ),
            onTapIconHeader: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return Home();
                  },
                ),
              );
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              headerTitle(),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 150.0,
              bottom: 300.0,
            ),
            sliver: body(),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return SliverList(
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
    );
  }

  Widget headerTitle() {
    return Padding(
      padding: const EdgeInsets.all(
        90.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Text(
            'About',
            style: TextStyle(
              fontSize: 70.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
                  color: Colors.white,
                ),
              ),
              icon: Icon(LineAwesomeIcons.github),
              label: Text(
                'Github',
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
                  color: Colors.white,
                ),
              ),
              icon: Icon(LineAwesomeIcons.box_open),
              label: Text(
                'rootasjey.dev',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
