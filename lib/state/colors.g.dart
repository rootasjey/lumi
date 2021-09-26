// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colors.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StateColors on StateColorsBase, Store {
  final _$appBackgroundAtom = Atom(name: 'StateColorsBase.appBackground');

  @override
  Color get appBackground {
    _$appBackgroundAtom.reportRead();
    return super.appBackground;
  }

  @override
  set appBackground(Color value) {
    _$appBackgroundAtom.reportWrite(value, super.appBackground, () {
      super.appBackground = value;
    });
  }

  final _$backgroundAtom = Atom(name: 'StateColorsBase.background');

  @override
  Color get background {
    _$backgroundAtom.reportRead();
    return super.background;
  }

  @override
  set background(Color value) {
    _$backgroundAtom.reportWrite(value, super.background, () {
      super.background = value;
    });
  }

  final _$foregroundAtom = Atom(name: 'StateColorsBase.foreground');

  @override
  Color get foreground {
    _$foregroundAtom.reportRead();
    return super.foreground;
  }

  @override
  set foreground(Color value) {
    _$foregroundAtom.reportWrite(value, super.foreground, () {
      super.foreground = value;
    });
  }

  final _$iconExtAtom = Atom(name: 'StateColorsBase.iconExt');

  @override
  String get iconExt {
    _$iconExtAtom.reportRead();
    return super.iconExt;
  }

  @override
  set iconExt(String value) {
    _$iconExtAtom.reportWrite(value, super.iconExt, () {
      super.iconExt = value;
    });
  }

  final _$softBackgroundAtom = Atom(name: 'StateColorsBase.softBackground');

  @override
  Color get softBackground {
    _$softBackgroundAtom.reportRead();
    return super.softBackground;
  }

  @override
  set softBackground(Color value) {
    _$softBackgroundAtom.reportWrite(value, super.softBackground, () {
      super.softBackground = value;
    });
  }

  final _$refreshThemeAsyncAction = AsyncAction('StateColorsBase.refreshTheme');

  @override
  Future<void> refreshTheme({Brightness brightness}) {
    return _$refreshThemeAsyncAction
        .run(() => super.refreshTheme(brightness: brightness));
  }

  @override
  String toString() {
    return '''
appBackground: ${appBackground},
background: ${background},
foreground: ${foreground},
iconExt: ${iconExt},
softBackground: ${softBackground}
    ''';
  }
}
