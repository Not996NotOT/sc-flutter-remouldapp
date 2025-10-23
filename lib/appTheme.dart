import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color themeBlue = Color(0xFF008AFD);
  static const Color Text_max = Color(0xFF333333);
  static const Color Text_min = Color(0xFFA1A1A1);
  static const Color Text_a = Color(0xFFA7A7A7);
  static const Color bg_b = Color(0xFFeeeeee);
  static const Color bg_c = Color(0xFFf0f0f0);
  static const Color bg_d = Color(0xFFf2f2f5);
  static const Color bg_e = Color(0xFFF5F5F5);
  static const Color bg_f = Color(0xff828282);
  static const List<Color> App_bar = [Colors.blue, Color(0xFF008AFD)];
  static const String fontName = 'WorkSans';
  static const Color textBlue = Color.fromRGBO(1, 137, 255, 1);
  static const Color textBlue_1 = Color.fromRGBO(224, 244, 252, 1);
  static const Color textBlue_2 = Color.fromRGBO(10, 54, 93, 1);
  static const Color textBlue_3 = Color.fromRGBO(35, 139, 216, 1);
  static const Color textBlack = Color.fromRGBO(51, 51, 51, 1);
  static const Color textBlack_1 = Color.fromRGBO(102, 102, 102, 1);
  static const Color textBlack_3 = Color.fromRGBO(38, 38, 38, 1);
  static const Color textBlack_4 = Color.fromRGBO(124, 128, 130, 1);
  static const Color textGreen = Color.fromRGBO(70, 217, 168, 1);
  static const Color textOrange = Color.fromRGBO(255, 241, 232, 1);
  static const Color textOrange_1 = Color.fromRGBO(255, 159, 88, 1);

  // static const TextTheme textTheme = TextTheme(
  //   display1: display1,
  //   headline: headline,
  //   title: title,
  //   subtitle: subtitle,
  //   body2: body2,
  //   body1: body1,
  //   caption: caption,
  // );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static Color getGarbageColor(String type) {
    switch (type) {
      case "2":
        return Color(0xFF4d94d9);
        break;
      case "4":
        return Color(0xFFa4a1a1);
        break;
      case "3":
        return Color(0xFFe76a74);
        break;
      case "1":
        return Color(0xFF42c079);
        break;
    }
    return Color(0xFFa4a1a1);
  }

  static Color getGarbageStatus(String type) {
    switch (type) {
      case "0":
        return Color(0xFF42c079);
        break;
    }
    return Color(0xFFa4a1a1);
  }

  static Color getGarbageBgColor(String type) {
    switch (type) {
      case "2":
        return Color(0xFFe0f0ff);
        break;
      case "4":
        return Color(0xFFf4f4f4);
        break;
      case "3":
        return Color(0xFFffe9eb);
        break;
      case "1":
        return Color(0xFFddf9e9);
        break;
    }
    return Color(0xFFf4f4f4);
  }
}
