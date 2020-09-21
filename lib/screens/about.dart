import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/router/router.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final titleStyle = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w200,
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
          HomeAppBar(),

          SliverList(
            delegate: SliverChildListDelegate([
              headerTitle(),
            ]),
          ),

          SliverPadding(
            padding: const EdgeInsets.only(
              left: 150.0,
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
              onPressed: () => FluroRouter.router.pop(context),
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
        top: 40.0,
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
                "This is my personal website where you'll find projects that I'm working on, some hobbies I want to share and how to contact me.",
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
                "This website has been crafted by hand with Flutter & Firebase.\nAfter testing multiple solutions, I ended up here because it seems the cheapest and most flexble way for my usage.",
                style: paragraphStyle,
              ),
            ),
          ),

          Opacity(
            opacity: paragraphOpacity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                "If you want to learn how the technology behind this website, visit the GitHub repository. or stay tuned for future blog posts explanations.",
                style: paragraphStyle,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: FlatButton.icon(
              onPressed: () => launch('https://github.com/rootasjey/rootasjey.dev'),
              icon: Icon(Icons.open_in_browser),
              label: Text(
                'Github',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
