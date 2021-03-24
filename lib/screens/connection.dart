import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:hue_api/hue_dart.dart' hide Timer;
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/screens/home.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/constants.dart';
import 'package:supercharged/supercharged.dart';

class Connection extends StatefulWidget {
  final void Function(bool isAuthenticated) onSigninResult;

  const Connection({Key key, this.onSigninResult}) : super(key: key);

  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  int maxAttempts = 15;
  int attempts = 0;

  final delay = 5.0;
  double maxTime = 0.0;
  double currTime = 0.0;
  bool isConnecting = false;

  final scrollController = ScrollController();

  Timer timer;

  @override
  initState() {
    super.initState();

    maxTime = maxAttempts * delay;
    currTime = maxTime;

    if (userState.isUserConnected) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return Home();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            title: Text(
              'lumi',
              style: TextStyle(
                fontSize: 50.0,
              ),
            ),
            onTapIconHeader: () {
              scrollController.animateTo(
                0,
                duration: 250.milliseconds,
                curve: Curves.decelerate,
              );
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 100.0,
            ),
          ),
          header(),
          body(),
          SliverPadding(
            padding: const EdgeInsets.only(
              bottom: 200.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 108.0,
        vertical: 30.0,
      ),
      sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
          ),
          child: Row(
            children: [
              Text(
                "CONNECT",
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
              ),
              Icon(Icons.arrow_forward),
              Icon(Icons.arrow_back),
            ],
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Text(
            "Please push the link button on your Hue bridge",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ])),
    );
  }

  Widget body() {
    if (!isConnecting) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: 108.0,
        ),
        sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => startConnect(),
                  style: ElevatedButton.styleFrom(
                    primary: stateColors.primary,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: Text('CONNECT TO BRIDGE'),
                ),
              ],
            ),
          ]),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 108.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  'assets/images/bridge_v2.png',
                  width: 200.0,
                  height: 200.0,
                  color: stateColors.foreground,
                ),
              ),
              LinearProgressIndicator(
                value: currTime / maxTime,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 40.0,
                ),
                child: Text(
                  currTime.toInt().toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => stopConnect(),
                style: ElevatedButton.styleFrom(
                  primary: stateColors.primary,
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Text('CANCEL'),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void connectLoop() async {
    if (attempts >= maxAttempts) {
      return;
    }

    attempts++;

    try {
      final client = Client();
      final discovery = BridgeDiscovery(client);

      final discoveryResults = await discovery.automatic();

      if (discoveryResults.isEmpty) {
        return;
      }

      final firstResult = discoveryResults.first;
      final bridge = Bridge(client, firstResult.ipAddress);

      final whiteListItem = await bridge.createUser('lumi#desktop');
      bridge.username = whiteListItem.username;

      await Hive.box(KEY_SETTINGS).put(KEY_USER_NAME, whiteListItem.username);

      userState.setBridge(bridge);
      userState.setUserConnected();

      stopConnect();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return Home();
        },
      ));
    } catch (error) {
      debugPrint(error.toString());

      Future.delayed(
        5.seconds,
        () => connectLoop(),
      );
    }
  }

  void startConnect() {
    setState(() {
      isConnecting = true;
      attempts = 0;
      currTime = maxTime;
    });

    connectLoop();

    timer = Timer.periodic(1.seconds, (timer) {
      if (currTime <= 0) {
        timer.cancel();
        return;
      }

      setState(() => currTime--);
    });
  }

  void stopConnect() {
    if (timer != null) {
      timer.cancel();
    }

    attempts = maxAttempts;

    setState(() => isConnecting = false);
  }
}
