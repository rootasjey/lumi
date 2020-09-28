import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/browser_client.dart';
import 'package:hue_dart/hue_dart.dart';
import 'package:lumi/components/full_page_loading.dart';
import 'package:lumi/main_web.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/constants.dart';

void main() {
  runApp(App());
}
class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
  bool isReady = false;

  @override
  void initState() {
    super.initState();

    Hive.openBox(KEY_SETTINGS)
    .then((_) {
      final settingsBox = Hive.box(KEY_SETTINGS);

      if (!settingsBox.containsKey(KEY_AUTO_BRIGHTNESS)) {
        settingsBox.put(KEY_AUTO_BRIGHTNESS, true);
      }

      if (!settingsBox.containsKey(KEY_DARK_MODE)) {
        settingsBox.put(KEY_DARK_MODE, true);
      }
    })
    .then((_) => autoLogin());
  }

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          stateColors.themeData = theme;
          return MainWeb();
        },
      );
    }

    return MaterialApp(
      title: 'Out Of Context',
      home: Scaffold(
        body: FullPageLoading(),
      ),
    );
  }

  void autoLogin() async {
    try {
      // final username = appLocalStorage.getUserName();

      // if (username == null || username.isEmpty) {
      //   return;
      // }

      final client = BrowserClient();
      final discovery = BridgeDiscovery(client);

      final discoveryResults = await discovery.automatic();

      if (discoveryResults.isEmpty) {
        return;
      }

      final firstResult = discoveryResults.first;
      final bridge = Bridge(client, firstResult.ipAddress);
      bridge.username = 'IgG6uNukt9xndp4cyFX1To0zjDmeiUzj5pwXxEwP';

      userState.setBridge(bridge);
      userState.setUserConnected();

      setState(() => isReady = true);

    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
