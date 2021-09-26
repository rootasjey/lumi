import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:lumi/screens/undefined_page.dart';

class UndefinedLocation extends BeamLocation {
  /// Main root value for this location.
  static const String route = '*';

  @override
  List<String> get pathBlueprints => [route];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        child: UndefinedPage(),
        key: ValueKey(route),
        title: "404",
        type: BeamPageType.fadeTransition,
      ),
    ];
  }
}
