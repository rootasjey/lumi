import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lumi/components/side_menu_item.dart';
import 'package:lumi/router/locations/home_location.dart';
import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/constants.dart';
import 'package:lumi/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:supercharged/supercharged.dart';

class HomeSideMenu extends StatefulWidget {
  const HomeSideMenu({
    Key key,
    this.beamerKey,
  }) : super(key: key);

  final GlobalKey<BeamerState> beamerKey;

  @override
  _HomeSideMenuState createState() => _HomeSideMenuState();
}

class _HomeSideMenuState extends State<HomeSideMenu> {
  BeamerDelegate _beamerDelegate;

  /// True if the side menu is expanded showing icons and labels.
  /// If false, the side menu shows only icon.
  /// Default to true.
  bool _isExpanded = true;

  final _sidePanelItems = <SideMenuItem>[
    SideMenuItem(
      iconData: UniconsLine.lightbulb_alt,
      label: "lights",
      hoverColor: Colors.blue,
      routePath: HomeContentLocation.lightsRoute,
    ),
    SideMenuItem(
      iconData: UniconsLine.dice_one,
      label: "sensors",
      hoverColor: Colors.green,
      routePath: HomeContentLocation.sensorsRoute,
    ),
    SideMenuItem(
      iconData: UniconsLine.bed_double,
      label: "scenes",
      hoverColor: Colors.amber,
      routePath: HomeContentLocation.groupsRoute,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // NOTE: Beamer state isn't ready on 1st frame
    // probably because [SidePanelMenu] appears before the Beamer widget.
    // So we use [addPostFrameCallback] to access the state in the next frame.
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.beamerKey.currentState != null) {
        _beamerDelegate = widget.beamerKey.currentState.routerDelegate;
        _beamerDelegate.addListener(_setStateListener);
      }
    });
  }

  @override
  void dispose() {
    _beamerDelegate.removeListener(_setStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < Constants.maxMobileWidth) {
      return Container();
    }

    return Material(
      elevation: 8.0,
      child: AnimatedContainer(
        duration: 500.milliseconds,
        curve: Curves.easeOutExpo,
        width: _isExpanded ? 260.0 : 70.0,
        child: Stack(
          children: [
            OverflowBox(
              minWidth: 40.0,
              maxWidth: 300.0,
              alignment: Alignment.topLeft,
              child: Center(
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    bodySidePanel(),
                  ],
                ),
              ),
            ),
            toggleExpandButton(),
          ],
        ),
      ),
    );
  }

  Widget bodySidePanel() {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: _isExpanded ? 20.0 : 16.0,
        right: 20.0,
      ),
      sliver: SliverList(
          delegate: SliverChildListDelegate.fixed(
        _sidePanelItems.map((sidePanelItem) {
          Color color = stateColors.foreground.withOpacity(0.6);
          Color textColor = stateColors.foreground.withOpacity(0.4);
          FontWeight fontWeight = FontWeight.w600;

          if (context.currentBeamLocation.state.uri.path
              .contains(sidePanelItem.routePath)) {
            color = sidePanelItem.hoverColor;
            textColor = stateColors.foreground.withOpacity(0.6);
            fontWeight = FontWeight.w700;
          }

          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: _isExpanded ? 24.0 : 0.0,
                top: 32.0,
              ),
              child: TextButton.icon(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    sidePanelItem.iconData,
                    color: color,
                  ),
                ),
                label: Text(
                  sidePanelItem.label,
                  style: FontsUtils.mainStyle(
                    color: textColor,
                    fontSize: 16.0,
                    fontWeight: fontWeight,
                  ),
                ),
                onPressed: () {
                  context.beamToNamed(sidePanelItem.routePath);
                  setState(() {});
                },
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  Widget toggleExpandButton() {
    return Positioned(
      bottom: 24.0,
      left: _isExpanded ? 32.0 : 16.0,
      child: Opacity(
        opacity: 0.6,
        child: IconButton(
          tooltip: _isExpanded ? "collapse" : "expand",
          icon: _isExpanded
              ? Icon(UniconsLine.arrow_from_right)
              : Icon(UniconsLine.left_arrow_from_left),
          onPressed: _toggleSideMenu,
        ),
      ),
    );
  }

  void _setStateListener() => setState(() {});

  void _toggleSideMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      // appStorage.setDashboardSideMenuExpanded(_isExpanded);
    });
  }
}
