import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fonts utilities.
/// Make it easier to work with online Google fonts.
///
/// See https://github.com/material-foundation/google-fonts-flutter/issues/35
class FontsUtils {
  static String fontFamily = GoogleFonts.hammersmithOne().fontFamily;

  /// Return main text style for this app.
  static TextStyle mainStyle({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    Color color,
  }) {
    if (color == null) {
      return GoogleFonts.hammersmithOne(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    }

    return GoogleFonts.hammersmithOne(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  /// Return main text style for this app.
  static TextStyle boldTitleStyle() {
    return GoogleFonts.pacifico(
      fontSize: 80.0,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle titleStyle({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    Color color,
  }) {
    if (color == null) {
      return GoogleFonts.pacifico(
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    }

    return GoogleFonts.pacifico(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}
