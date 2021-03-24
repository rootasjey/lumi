import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lumi/components/app_icon.dart';
import 'package:lumi/router/app_router.gr.dart';
import 'package:lumi/utils/fonts.dart';

class AppPresentation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              header(),
              connectionButton(context),
            ]),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                ),
                Text(
                  "Lumi",
                  style: FontsUtils.mainStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              "presentation_subtitle".tr(),
              style: FontsUtils.mainStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget connectionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              context.router.push(ConnectionRoute());
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "connection",
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
