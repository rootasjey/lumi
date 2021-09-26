import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hue_api/hue_dart.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/router/locations/home_location.dart';
import 'package:lumi/state/user_state.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scrollController = ScrollController();
  bool isLoading = false;

  Configuration config;

  @override
  initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            automaticallyImplyLeading: true,
            onTapIconHeader: () {
              Beamer.of(context).beamToNamed(HomeLocation.route);
            },
          ),
          header(),
          body(),
          SliverPadding(
            padding: const EdgeInsets.only(
              bottom: 200.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 108.0,
        vertical: 30.0,
      ),
      sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
          ),
          child: Row(
            children: [
              Text(
                "BRIDGE",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ])),
    );
  }

  Widget body() {
    if (isLoading) {
      return SliverPadding(
        padding: EdgeInsets.zero,
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 110.0,
      ),
      sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ),
          child: Opacity(
            opacity: 0.6,
            child: Text(
              config.name,
              style: TextStyle(
                fontSize: 40.0,
              ),
            ),
          ),
        ),
        infoRow(
          key: 'Bridge ID: ',
          value: config.bridgeId,
        ),
        infoRow(
          key: 'Model ID: ',
          value: config.modelId,
        ),
        infoRow(
          key: 'API version: ',
          value: config.apiVersion,
        ),
        infoRow(
          key: 'Data store version: ',
          value: config.dataStoreVersion,
        ),
        infoRow(
          key: 'MAC address: ',
          value: config.mac,
        ),
        infoRow(
          key: 'IP address: ',
          value: config.ipAddress,
        ),
        infoRow(
          key: 'Gateway: ',
          value: config.gateway,
        ),
        infoRow(
          key: 'Mask: ',
          value: config.netMask,
        ),
        infoRow(
          key: 'Proxy: ',
          value: config.proxyAddress,
        ),
        infoRow(
          key: 'Proxy port: ',
          value: config.proxyPort.toString(),
        ),
        infoRow(
          key: 'Software version: ',
          value: config.swVersion,
        ),
        infoRow(
          key: 'Timezone: ',
          value: config.timeZone,
        ),
        infoRow(
          key: 'Update available: ',
          value: config.softwareUpdate.state,
        ),
      ])),
    );
  }

  Widget infoRow({String key, String value}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: Row(
        children: [
          Opacity(
            opacity: 0.6,
            child: Text(
              key,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Opacity(
            opacity: 0.8,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetch() async {
    setState(() => isLoading = true);

    try {
      config = await userState.bridge.configuration();
      setState(() => isLoading = false);
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
