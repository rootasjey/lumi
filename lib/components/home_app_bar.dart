import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';
import 'package:lumi/components/app_icon.dart';
import 'package:lumi/router/locations/about_location.dart';
import 'package:lumi/router/locations/connect_location.dart';
import 'package:lumi/router/route_names.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/brightness.dart';
import 'package:lumi/utils/constants.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class HomeAppBar extends StatefulWidget {
  final bool automaticallyImplyLeading;
  final Function onTapIconHeader;
  final Widget title;
  final VoidCallback onPressedRightButton;

  HomeAppBar({
    this.automaticallyImplyLeading = false,
    this.onTapIconHeader,
    this.title,
    this.onPressedRightButton,
  });

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constrains) {
        final isNarrow = constrains.crossAxisExtent < 700.0;
        final leftPadding = isNarrow ? 0.0 : 80.0;
        final AdaptiveThemeManager adaptiveTheme = AdaptiveTheme.of(context);

        return ValueListenableBuilder(
          valueListenable: adaptiveTheme.modeChangeNotifier,
          builder: (_, mode, child) {
            return SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              expandedHeight: 140.0,
              backgroundColor: adaptiveTheme.theme.canvasColor,
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: 48.0,
                  left: leftPadding,
                  right: leftPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    if (widget.automaticallyImplyLeading)
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          onPressed: Beamer.of(context).popRoute,
                          icon: Icon(UniconsLine.arrow_left),
                        ),
                      ),
                    AppIcon(
                      padding: EdgeInsets.zero,
                      onTap: widget.onTapIconHeader,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 4.0),
                        child: Text(
                          'lumi',
                          style: FontsUtils.titleStyle(
                            fontSize: 30.0,
                            color:
                                adaptiveTheme.theme.textTheme.bodyText1.color,
                          ),
                        ),
                      ),
                    ),
                    brightnessButton(),
                    menu(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Switch from dark to light and vice-versa.
  Widget brightnessButton() {
    IconData iconBrightness = UniconsLine.brightness_half;

    switch (AdaptiveTheme.of(context).mode) {
      case AdaptiveThemeMode.dark:
        iconBrightness = UniconsLine.adjust_half;
        break;
      case AdaptiveThemeMode.light:
        iconBrightness = UniconsLine.brightness;
        break;
      case AdaptiveThemeMode.system:
        iconBrightness = UniconsLine.brightness_half;
        break;
      default:
        iconBrightness = UniconsLine.brightness_half;
    }

    iconBrightness = BrightnessUtils.currentBrightness == Brightness.dark
        ? UniconsLine.adjust_half
        : UniconsLine.brightness;

    return PopupMenuButton<AdaptiveThemeMode>(
      icon: Opacity(
        opacity: 0.6,
        child: Icon(
          iconBrightness,
          color: AdaptiveTheme.of(context).theme.textTheme.bodyText1.color,
        ),
      ),
      tooltip: 'Brightness',
      onSelected: (AdaptiveThemeMode mode) {
        final AdaptiveThemeManager adaptiveThemeManager =
            AdaptiveTheme.of(context);

        if (mode == AdaptiveThemeMode.system) {
          adaptiveThemeManager.setSystem();
          return;
        }

        if (mode == AdaptiveThemeMode.dark) {
          adaptiveThemeManager.setDark();
          BrightnessUtils.currentBrightness = Brightness.dark;
          return;
        }

        if (mode == AdaptiveThemeMode.light) {
          adaptiveThemeManager.setLight();
          BrightnessUtils.currentBrightness = Brightness.light;
          return;
        }
      },
      itemBuilder: (context) => [
        // const PopupMenuItem(
        //   value: AdaptiveThemeMode.system,
        //   child: ListTile(
        //     leading: Icon(UniconsLine.brightness_half),
        //     title: Text('System'),
        //   ),
        // ),
        const PopupMenuItem(
          value: AdaptiveThemeMode.dark,
          child: ListTile(
            mouseCursor: MouseCursor.defer,
            leading: Icon(UniconsLine.adjust_half),
            title: Text('Dark'),
          ),
        ),
        const PopupMenuItem(
          value: AdaptiveThemeMode.light,
          child: ListTile(
            mouseCursor: MouseCursor.defer,
            leading: Icon(UniconsLine.brightness),
            title: Text('Light'),
          ),
        ),
      ],
    );
  }

  Widget menu() {
    bool isConnected = userState.isUserConnected;

    return PopupMenuButton(
      icon: Opacity(
        opacity: 0.6,
        child: Icon(
          Icons.more_vert,
          color: AdaptiveTheme.of(context).theme.textTheme.bodyText1.color,
        ),
      ),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        if (isConnected) ...[
          PopupMenuItem(
            value: 'disconnect',
            child: ListTile(
              mouseCursor: MouseCursor.defer,
              leading: Icon(UniconsLine.exit),
              title: Text('Disconnect'),
            ),
          ),
          PopupMenuItem(
            value: 'users',
            child: ListTile(
              mouseCursor: MouseCursor.defer,
              leading: Icon(UniconsLine.user),
              title: Text('Users'),
            ),
          ),
          PopupMenuItem(
            value: 'settings',
            child: ListTile(
              mouseCursor: MouseCursor.defer,
              leading: Icon(UniconsLine.setting),
              title: Text('Configuration'),
            ),
          ),
        ],
        PopupMenuItem(
          value: AboutRoute,
          child: ListTile(
            mouseCursor: MouseCursor.defer,
            leading: Icon(UniconsLine.question),
            title: Text('About'),
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'disconnect':
            disconnect();
            break;
          case 'users':
            Beamer.of(context).beamToNamed('/settings/users');
            break;
          case 'settings':
            Beamer.of(context).beamToNamed('/settings');
            break;
          case AboutRoute:
            Beamer.of(context).beamToNamed(AboutLocation.route);
            break;
          default:
        }
      },
    );
  }

  void disconnect() async {
    await Glutton.digest(KEY_USER_NAME);
    userState.bridge.username = '';
    userState.setUserDisconnected();

    Beamer.of(context).beamToNamed(ConnectLocation.route);
  }
}
