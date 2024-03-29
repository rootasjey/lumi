import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lumi/components/app_icon.dart';
import 'package:lumi/router/locations/connect_location.dart';

import 'package:lumi/utils/fonts.dart';

class AppPresentation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(80.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                header(),
                connectionButton(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                padding: const EdgeInsets.only(
                  right: 32.0,
                ),
              ),
              Text(
                "lumi",
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
    );
  }

  Widget connectionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              Beamer.of(context).beamToNamed(ConnectLocation.route);
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
