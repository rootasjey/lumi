import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lumi/components/app_icon.dart';
import 'package:lumi/router/route_names.dart';
import 'package:lumi/screens/about.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/app_localstorage.dart';
import 'package:lumi/utils/brightness.dart';

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
    return Observer(
      builder: (context) {
        return SliverLayoutBuilder(
          builder: (context, constrains) {
            final isNarrow = constrains.crossAxisExtent < 700.0;
            final leftPadding = isNarrow
              ? 0.0
              : 100.0;

            return SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              expandedHeight: 140.0,
              backgroundColor: stateColors.appBackground.withOpacity(1.0),
              automaticallyImplyLeading: false,
              // title: Padding(
              //   padding: EdgeInsets.only(
              //     top: 60.0,
              //     left: leftPadding,
              //   ),
              //   child:
              // ),
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
                          onPressed: () {},
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
    final autoBrightness = appLocalStorage.getAutoBrightness();

    if (!autoBrightness) {
      final currentBrightness = appLocalStorage.getBrightness();

      iconBrightness = currentBrightness == Brightness.dark
        ? Icons.brightness_2
        : Icons.brightness_low;
    }

    return PopupMenuButton<String>(
      icon: Icon(iconBrightness, color: stateColors.foreground,),
      tooltip: 'Brightness',
      onSelected: (value) {
        if (value == 'auto') {
          setAutoBrightness(context: context);
          return;
        }

        final brightness = value == 'dark'
          ? Brightness.dark
          : Brightness.light;

        setBrightness(brightness: brightness, context: context);
        DynamicTheme.of(context).setBrightness(brightness);
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
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: stateColors.foreground),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'disconnect',
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Disconnect'),
          ),
        ),

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
            break;
          case AboutRoute:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return About();
                },
              )
            );

            break;
          default:
        }
      },
    );
  }
}