import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive/hive.dart';
import 'package:lumi/components/app_icon.dart';
import 'package:lumi/router/route_names.dart';
import 'package:lumi/screens/about.dart';
import 'package:lumi/screens/config.dart';
import 'package:lumi/screens/connection.dart';
import 'package:lumi/screens/users.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/utils/brightness.dart';
import 'package:lumi/utils/constants.dart';

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
        final leftPadding = isNarrow ? 0.0 : 100.0;

        return Observer(
          builder: (context) {
            return SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              expandedHeight: 140.0,
              backgroundColor: stateColors.appBackground.withOpacity(1.0),
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: 80.0,
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
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                    AppIcon(
                      padding: EdgeInsets.zero,
                      onTap: widget.onTapIconHeader,
                    ),
                    if (widget.title != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: widget.title,
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
    bool autoBrightness = Hive.box(KEY_SETTINGS).get(KEY_AUTO_BRIGHTNESS);

    if (!autoBrightness) {
      bool darkMode = Hive.box(KEY_SETTINGS).get(KEY_DARK_MODE);

      iconBrightness = darkMode ? Icons.brightness_2 : Icons.brightness_low;
    }

    return PopupMenuButton<String>(
      icon: Icon(
        iconBrightness,
        color: stateColors.foreground,
      ),
      tooltip: 'Brightness',
      onSelected: (value) {
        if (value == 'auto') {
          BrightnessUtils.setAutoBrightness(context);
          return;
        }

        final brightness = value == 'dark' ? Brightness.dark : Brightness.light;
        BrightnessUtils.setBrightness(context, brightness);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'auto',
          child: ListTile(
            leading: Icon(Icons.brightness_auto),
            title: Text('Auto'),
          ),
        ),
        const PopupMenuItem(
          value: 'dark',
          child: ListTile(
            leading: Icon(Icons.brightness_2),
            title: Text('Dark'),
          ),
        ),
        const PopupMenuItem(
          value: 'light',
          child: ListTile(
            leading: Icon(Icons.brightness_5),
            title: Text('Light'),
          ),
        ),
      ],
    );
  }

  Widget menu() {
    bool isConnected = userState.isUserConnected;

    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: stateColors.foreground),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        if (isConnected) ...[
          PopupMenuItem(
            value: 'disconnect',
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Disconnect'),
            ),
          ),
          PopupMenuItem(
            value: 'users',
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Users'),
            ),
          ),
          PopupMenuItem(
            value: 'config',
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuration'),
            ),
          ),
        ],
        PopupMenuItem(
          value: AboutRoute,
          child: ListTile(
            leading: Icon(Icons.help),
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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => UsersPage()),
            );
            break;
          case 'config':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ConfigPage()),
            );
            break;
          case AboutRoute:
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => About()),
            );

            break;
          default:
        }
      },
    );
  }

  void disconnect() async {
    await Hive.box(KEY_SETTINGS).put(KEY_USER_NAME, '');
    userState.bridge.username = '';
    userState.setUserDisconnected();

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return Connection();
      }),
    );
  }
}
