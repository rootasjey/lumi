// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserState on UserStateBase, Store {
  final _$avatarUrlAtom = Atom(name: 'UserStateBase.avatarUrl');

  @override
  String get avatarUrl {
    _$avatarUrlAtom.reportRead();
    return super.avatarUrl;
  }

  @override
  set avatarUrl(String value) {
    _$avatarUrlAtom.reportWrite(value, super.avatarUrl, () {
      super.avatarUrl = value;
    });
  }

  final _$homeSectionTitleAtom = Atom(name: 'UserStateBase.homeSectionTitle');

  @override
  String get homeSectionTitle {
    _$homeSectionTitleAtom.reportRead();
    return super.homeSectionTitle;
  }

  @override
  set homeSectionTitle(String value) {
    _$homeSectionTitleAtom.reportWrite(value, super.homeSectionTitle, () {
      super.homeSectionTitle = value;
    });
  }

  final _$langAtom = Atom(name: 'UserStateBase.lang');

  @override
  String get lang {
    _$langAtom.reportRead();
    return super.lang;
  }

  @override
  set lang(String value) {
    _$langAtom.reportWrite(value, super.lang, () {
      super.lang = value;
    });
  }

  final _$isQuotidianNotifActiveAtom =
      Atom(name: 'UserStateBase.isQuotidianNotifActive');

  @override
  bool get isQuotidianNotifActive {
    _$isQuotidianNotifActiveAtom.reportRead();
    return super.isQuotidianNotifActive;
  }

  @override
  set isQuotidianNotifActive(bool value) {
    _$isQuotidianNotifActiveAtom
        .reportWrite(value, super.isQuotidianNotifActive, () {
      super.isQuotidianNotifActive = value;
    });
  }

  final _$isUserConnectedAtom = Atom(name: 'UserStateBase.isUserConnected');

  @override
  bool get isUserConnected {
    _$isUserConnectedAtom.reportRead();
    return super.isUserConnected;
  }

  @override
  set isUserConnected(bool value) {
    _$isUserConnectedAtom.reportWrite(value, super.isUserConnected, () {
      super.isUserConnected = value;
    });
  }

  final _$usernameAtom = Atom(name: 'UserStateBase.username');

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  final _$updatedFavAtAtom = Atom(name: 'UserStateBase.updatedFavAt');

  @override
  DateTime get updatedFavAt {
    _$updatedFavAtAtom.reportRead();
    return super.updatedFavAt;
  }

  @override
  set updatedFavAt(DateTime value) {
    _$updatedFavAtAtom.reportWrite(value, super.updatedFavAt, () {
      super.updatedFavAt = value;
    });
  }

  final _$UserStateBaseActionController =
      ActionController(name: 'UserStateBase');

  @override
  void setAvatarUrl(String url) {
    final _$actionInfo = _$UserStateBaseActionController.startAction(
        name: 'UserStateBase.setAvatarUrl');
    try {
      return super.setAvatarUrl(url);
    } finally {
      _$UserStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHomeSectionTitle(String title) {
    final _$actionInfo = _$UserStateBaseActionController.startAction(
        name: 'UserStateBase.setHomeSectionTitle');
    try {
      return super.setHomeSectionTitle(title);
    } finally {
      _$UserStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLang(String newLang) {
    final _$actionInfo = _$UserStateBaseActionController.startAction(
        name: 'UserStateBase.setLang');
    try {
      return super.setLang(newLang);
    } finally {
      _$UserStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserConnected() {
    final _$actionInfo = _$UserStateBaseActionController.startAction(
        name: 'UserStateBase.setUserConnected');
    try {
      return super.setUserConnected();
    } finally {
      _$UserStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserDisconnected() {
    final _$actionInfo = _$UserStateBaseActionController.startAction(
        name: 'UserStateBase.setUserDisconnected');
    try {
      return super.setUserDisconnected();
    } finally {
      _$UserStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserName(String name) {
    final _$actionInfo = _$UserStateBaseActionController.startAction(
        name: 'UserStateBase.setUserName');
    try {
      return super.setUserName(name);
    } finally {
      _$UserStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateFavDate() {
    final _$actionInfo = _$UserStateBaseActionController.startAction(
        name: 'UserStateBase.updateFavDate');
    try {
      return super.updateFavDate();
    } finally {
      _$UserStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
avatarUrl: ${avatarUrl},
homeSectionTitle: ${homeSectionTitle},
lang: ${lang},
isQuotidianNotifActive: ${isQuotidianNotifActive},
isUserConnected: ${isUserConnected},
username: ${username},
updatedFavAt: ${updatedFavAt}
    ''';
  }
}
