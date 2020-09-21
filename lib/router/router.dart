import 'package:fluro/fluro.dart';
import 'package:lumi/router/route_names.dart';
import 'package:lumi/router/web/route_handlers.dart';

class FluroRouter {
  static Router router = Router();
  static bool isReady = false;

  static void setupMobileRouter() {}

  static void setupWebRouter() {
    router.define(
      AboutRoute,
      handler: WebRouteHandlers.about,
    );

    router.define(
      RootRoute,
      handler: WebRouteHandlers.home,
    );
  }
}
