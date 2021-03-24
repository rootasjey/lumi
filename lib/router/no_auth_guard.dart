import 'package:lumi/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:lumi/state/user_state.dart';

class NoAuthGuard extends AutoRouteGuard {
  @override
  Future<bool> canNavigate(
    List<PageRouteInfo> pendingRoutes,
    StackRouter router,
  ) async {
    if (!userState.isUserConnected) {
      return true;
    }

    router.root.replace(HomeRoute());
    return false;
  }
}
