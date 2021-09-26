import 'package:lumi/state/colors.dart';
import 'package:lumi/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supercharged/supercharged.dart';

import '../components/home_app_bar.dart';

/// Terms Of Service.
class TosPage extends StatefulWidget {
  @override
  _TosPageState createState() => _TosPageState();
}

class _TosPageState extends State<TosPage> {
  bool isFabVisible = false;

  final _pageScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double horPadding = 80.0;

    if (width < Constants.maxMobileWidth) {
      horPadding = 20.0;
    }

    return Scaffold(
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
              onPressed: () {
                _pageScrollController.animateTo(
                  0.0,
                  duration: 500.milliseconds,
                  curve: Curves.easeOut,
                );
              },
              backgroundColor: stateColors.primary,
              foregroundColor: Colors.white,
              child: Icon(Icons.arrow_upward),
            )
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotif) {
          // FAB visibility
          if (scrollNotif.metrics.pixels < 50 && isFabVisible) {
            setState(() => isFabVisible = false);
          } else if (scrollNotif.metrics.pixels > 50 && !isFabVisible) {
            setState(() => isFabVisible = true);
          }
          return false;
        },
        child: CustomScrollView(
          controller: _pageScrollController,
          slivers: [
            HomeAppBar(
              automaticallyImplyLeading: true,
              title: Text("privacy".tr()),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: horPadding,
                vertical: 60.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Column(
                    children: [
                      SizedBox(
                        width: 600.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            termsBlock(),
                            cookiesBlock(),
                            analyticsBlock(),
                            advertisingBlock(),
                            inAppPurchasesBlock(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cookiesBlock() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      titleBlock(text: 'cookies'.tr()),
      textSuperBlock(text: 'cookies_content'.tr()),
    ]);
  }

  Widget analyticsBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBlock(text: 'analytics'.tr()),
        textSuperBlock(text: 'analytics_content'.tr()),
      ],
    );
  }

  Widget advertisingBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBlock(text: 'avertising'.tr()),
        textSuperBlock(text: 'avertising_content'.tr()),
      ],
    );
  }

  Widget inAppPurchasesBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleBlock(text: 'iap'.tr()),
        textSuperBlock(text: 'iap_content'.tr()),
      ],
    );
  }

  Widget termsBlock() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              "tos".tr(),
              style: TextStyle(
                fontSize: 50.0,
                color: stateColors.primary,
              ),
            ),
          ),
          textSuperBlock(text: "tos_1".tr()),
          textSuperBlock(text: "tos_2".tr()),
          textSuperBlock(text: "tos_3".tr()),
          textSuperBlock(text: "tos_4".tr()),
          textSuperBlock(text: "tos_5".tr()),
          textSuperBlock(text: "tos_6".tr()),
          textSuperBlock(text: "tos_7".tr()),
          textSuperBlock(text: "tos_8".tr()),
          Text.rich(
            TextSpan(
              text: "tos_created_with".tr(),
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch("https://getterms.io/");
                },
            ),
          ),
        ],
      ),
    );
  }

  Widget titleBlock({@required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 16.0),
      child: Opacity(
        opacity: 1.0,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: stateColors.primary,
          ),
        ),
      ),
    );
  }

  Widget textSuperBlock({@required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Opacity(
        opacity: 0.8,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
