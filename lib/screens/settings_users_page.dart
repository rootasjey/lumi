import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lumi/components/home_app_bar.dart';
import 'package:lumi/router/locations/home_location.dart';
import 'package:lumi/state/user_state.dart';
import 'package:lumi/types/user.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsUsersPage extends StatefulWidget {
  @override
  _SettingsUsersPageState createState() => _SettingsUsersPageState();
}

class _SettingsUsersPageState extends State<SettingsUsersPage> {
  final scrollController = ScrollController();
  List<User> usersList = [];

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
            title: Text(
              'lumi',
              style: TextStyle(
                fontSize: 50.0,
              ),
            ),
            onTapIconHeader: () {
              Beamer.of(context).beamToNamed(HomeLocation.route);
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 100.0,
            ),
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
              Opacity(
                opacity: 0.8,
                child: Text(
                  "USERS",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
              ),
              Opacity(
                opacity: 0.8,
                child: Icon(
                  UniconsLine.user,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Text(
            "Authorized users on the bridge",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 38.0,
            bottom: 10.0,
          ),
          child: Opacity(
            opacity: 0.5,
            child: Text(
              "Hue API doesn't allow you to delete user from third party apps like lumi. Please go to their official website.",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => launch("https://account.meethue.com/apps"),
              icon: Icon(Icons.open_in_browser),
              label: Text(
                "https://account.meethue.com/apps",
              ),
            ),
          ],
        ),
      ])),
    );
  }

  Widget body() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 100.0,
        vertical: 60.0,
      ),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          final user = usersList[index];

          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                isThreeLine: true,
                title: Opacity(
                  opacity: 0.8,
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.6,
                            child: Icon(Icons.person_add),
                          ),
                          Text(
                            'CREATED: ${Jiffy(user.created).fromNow()}',
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                      ),
                      Wrap(
                        spacing: 10.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.6,
                            child: Icon(Icons.access_time),
                          ),
                          Text(
                            'LAST USED: ${Jiffy(user.lastUsed).fromNow()}',
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: usersList.length,
      )),
    );
  }

  void fetch() async {
    try {
      final config = await userState.bridge.configuration();

      config.whitelist.forEach((username, whiteListItem) {
        usersList.add(
          User(
            username: username,
            lastUsedDate: whiteListItem.lastUsedDate,
            createDate: whiteListItem.createDate,
            name: whiteListItem.name,
          ),
        );
      });

      setState(() {});
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void deleteUser(User user) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Delete user'),
            content: SingleChildScrollView(
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  "Are you sure you want to delete ${user.name}?",
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    Navigator.of(context).pop();
                    print(user.username);

                    final response =
                        await userState.bridge.deleteUser(user.username);

                    if (response.errors.isEmpty) {
                      setState(() {
                        usersList.remove(user);
                      });
                    }
                  } catch (error) {
                    debugPrint(error.toString());
                  }
                },
                child: Text('DELETE'),
              ),
            ],
          );
        });
  }
}
