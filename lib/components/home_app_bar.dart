import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:glutton/glutton.dart';
import 'package:lumi/components/app_icon.dart';
import 'package:lumi/router/locations/about_location.dart';
import 'package:lumi/router/locations/connect_location.dart';
import 'package:lumi/router/route_names.dart';
import 'package:lumi/state/colors.dart';
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

        Widget _titleWidget = widget.title;
        if (_titleWidget == null) {
          _titleWidget = Text(
            'lumi',
            style: FontsUtils.titleStyle(
              fontSize: 30.0,
            ),
          );
        }

        return Observer(
          builder: (context) {
            return SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              expandedHeight: 140.0,
              backgroundColor: stateColors.appBackground.withOpacity(1.0),
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.only(
                  top: 12.0,
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
                          color: stateColors.foreground,
                          onPressed: Beamer.of(context).popRoute,
                          icon: Icon(UniconsLine.arrow_left),
                        ),
                      ),
                    AppIcon(
                      padding: EdgeInsets.zero,
                      onTap: widget.onTapIconHeader,
                    ),
                    if (_titleWidget != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: _titleWidget,
                        ),
                      ),
                    themeButton(),
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
  Widget themeButton() {
    IconData iconBrightness = Icons.brightness_auto;
    iconBrightness = BrightnessUtils.currentBrightness == Brightness.dark
        ? Icons.brightness_2
        : Icons.brightness_low;

    return Observer(builder: (context) {
      return PopupMenuButton<AdaptiveThemeMode>(
        icon: Opacity(
          opacity: 0.6,
          child: Icon(
            iconBrightness,
            color: stateColors.foreground,
          ),
        ),
        tooltip: 'Brightness',
        onSelected: (AdaptiveThemeMode mode) {
          if (mode == AdaptiveThemeMode.system) {
            AdaptiveTheme.of(context).setSystem();
            return;
          }

          if (mode == AdaptiveThemeMode.dark) {
            AdaptiveTheme.of(context).setDark();
            BrightnessUtils.currentBrightness = Brightness.dark;
            return;
          }

          if (mode == AdaptiveThemeMode.light) {
            AdaptiveTheme.of(context).setLight();
            BrightnessUtils.currentBrightness = Brightness.light;
            return;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: AdaptiveThemeMode.system,
            child: ListTile(
              leading: Icon(Icons.brightness_auto),
              title: Text('Auto'),
            ),
          ),
          const PopupMenuItem(
            value: AdaptiveThemeMode.dark,
            child: ListTile(
              leading: Icon(Icons.brightness_2),
              title: Text('Dark'),
            ),
          ),
          const PopupMenuItem(
            value: AdaptiveThemeMode.light,
            child: ListTile(
              leading: Icon(Icons.brightness_5),
              title: Text('Light'),
            ),
          ),
        ],
      );
    });
  }

  Widget menu() {
    bool isConnected = userState.isUserConnected;

    return PopupMenuButton(
      icon: Opacity(
        opacity: 0.6,
        child: Icon(
          Icons.more_vert,
          color: stateColors.foreground,
        ),
      ),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        if (isConnected) ...[
          PopupMenuItem(
            value: 'disconnect',
            child: ListTile(
              leading: Icon(UniconsLine.exit),
              title: Text('Disconnect'),
            ),
          ),
          PopupMenuItem(
            value: 'users',
            child: ListTile(
              leading: Icon(UniconsLine.user),
              title: Text('Users'),
            ),
          ),
          PopupMenuItem(
            value: 'settings',
            child: ListTile(
              leading: Icon(UniconsLine.setting),
              title: Text('Configuration'),
            ),
          ),
        ],
        PopupMenuItem(
          value: AboutRoute,
          child: ListTile(
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
