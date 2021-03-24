import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:hue_api/hue_dart.dart';
import 'package:lumi/router/app_router.gr.dart';
import 'package:lumi/router/auth_guard.dart';
import 'package:lumi/router/no_auth_guard.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/app_logger.dart';
import 'package:lumi/utils/constants.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(KEY_SETTINGS);

  await Future.wait([_autoLogin(), _initStorage()]);
  await EasyLocalization.ensureInitialized();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final brightness = savedThemeMode.isDark ? Brightness.dark : Brightness.light;

  setPathUrlStrategy();

  return runApp(EasyLocalization(
    path: 'assets/translations',
    supportedLocales: [Locale('en'), Locale('fr')],
    fallbackLocale: Locale('en'),
    child: App(
      savedThemeMode: savedThemeMode,
      brightness: brightness,
    ),
  ));
}

/// Main app class.
class App extends StatefulWidget {
  final AdaptiveThemeMode savedThemeMode;
  final Brightness brightness;

  const App({
    Key key,
    this.savedThemeMode,
    this.brightness,
  }) : super(key: key);

  AppState createState() => AppState();
}

/// Main app class state.
class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    stateColors.refreshTheme(brightness: widget.brightness);
    // stateUser.setFirstLaunch(appStorage.isFirstLanch());

    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        fontFamily: FontsUtils.fontFamily,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        fontFamily: FontsUtils.fontFamily,
      ),
      initial: widget.brightness == Brightness.light
          ? AdaptiveThemeMode.light
          : AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) {
        stateColors.themeData = theme;

        return AppWithTheme(
          brightness: widget.brightness,
          theme: theme,
          darkTheme: darkTheme,
        );
      },
    );
  }
}

/// Because we need a [context] with adaptive theme data available in it.
class AppWithTheme extends StatefulWidget {
  final ThemeData theme;
  final ThemeData darkTheme;
  final Brightness brightness;

  const AppWithTheme({
    Key key,
    @required this.brightness,
    @required this.darkTheme,
    @required this.theme,
  }) : super(key: key);

  @override
  _AppWithThemeState createState() => _AppWithThemeState();
}

class _AppWithThemeState extends State<AppWithTheme> {
  final appRouter = AppRouter(
    authGuard: AuthGuard(),
    noAuthGuard: NoAuthGuard(),
  );

  @override
  initState() {
    super.initState();
    Future.delayed(250.milliseconds, () {
      if (widget.brightness == Brightness.dark) {
        AdaptiveTheme.of(context).setDark();
        return;
      }

      AdaptiveTheme.of(context).setLight();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'lumi',
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}

Future _initStorage() async {
  final box = Hive.box(KEY_SETTINGS);

  if (box.isNotEmpty) {
    return;
  }

  if (!box.containsKey(KEY_AUTO_BRIGHTNESS)) {
    box.put(KEY_AUTO_BRIGHTNESS, true);
  }

  if (!box.containsKey(KEY_DARK_MODE)) {
    box.put(KEY_DARK_MODE, true);
  }
}

Future _autoLogin() async {
  try {
    final box = Hive.box(KEY_SETTINGS);

    if (box.isEmpty) {
      return;
    }

    String username = box.get(KEY_USER_NAME);

    if (username == null || username.isEmpty) {
      return;
    }

    final client = Client();
    final discovery = BridgeDiscovery(client);

    final discoveryResults = await discovery.automatic();

    if (discoveryResults.isEmpty) {
      return;
    }

    final firstResult = discoveryResults.first;
    final bridge = Bridge(client, firstResult.ipAddress);
    bridge.username = username;

    userState.setBridge(bridge);
    userState.setUserConnected();
  } catch (error) {
    appLogger.e(error);
  }
}
