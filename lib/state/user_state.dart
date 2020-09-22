import 'package:hue_dart/hue_dart.dart';
import 'package:mobx/mobx.dart';

part 'user_state.g.dart';

class UserState = UserStateBase with _$UserState;

abstract class UserStateBase with Store {
  @observable
  String avatarUrl = '';

  Bridge _bridge;

  Bridge get bridge => _bridge;

  @observable
  String homeSectionTitle = '';

  @observable
  String lang = 'en';

  @observable
  bool isQuotidianNotifActive = true;

  @observable
  bool isUserConnected = false;

  @observable
  String username = '';

  /// Last time the favourites has been updated.
  @observable
  DateTime updatedFavAt = DateTime.now();

  @action
  void setAvatarUrl(String url) {
    avatarUrl = url;
  }

  void setBridge(Bridge newBridge) {
    _bridge = newBridge;
  }

  @action
  void setHomeSectionTitle(String title) {
    homeSectionTitle = title;
  }

  @action
  void setLang(String newLang) {
    lang = newLang;
  }

  @action
  void setUserConnected() {
    isUserConnected = true;
  }

  @action
  void setUserDisconnected() {
    isUserConnected = false;
  }

  @action
  void setUserName(String name) {
    username = name;
  }

  @action
  void updateFavDate() {
    updatedFavAt = DateTime.now();
  }
}

final userState = UserState();
