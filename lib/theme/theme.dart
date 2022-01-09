import 'package:flutter/material.dart';

import 'light_color.dart';

class AppTheme {
  const AppTheme();
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: LightColor.primary,
    toggleableActiveColor: LightColor.accent,
    textTheme: TextTheme(
      headline1: h1Style,
      headline2: h2Style,
      headline3: h3Style,
      headline4: h4Style,
      headline5: h5Style,
      headline6: h6Style,
      subtitle1: titleStyle,
      subtitle2: subtitleStyle,
      bodyText1: bodyStyle,
      bodyText2: body2Style,
      caption: captionStyle,
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.deepPurple,
      accentColor: LightColor.accent,
    ),
  );

  static TextStyle h1Style = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: LightColor.black,
  );
  static TextStyle h2Style = const TextStyle(
    fontSize: 20,
    color: LightColor.black,
  );
  static TextStyle h3Style = const TextStyle(
    fontSize: 18,
    color: LightColor.black,
  );
  static TextStyle h4Style = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: LightColor.black,
  );
  static TextStyle h5Style = const TextStyle(
    fontSize: 14,
    color: LightColor.black,
  );
  static TextStyle h6Style = const TextStyle(color: LightColor.black); // used in headers

  static TextStyle titleStyle = const TextStyle(color: LightColor.black,);
  static TextStyle subtitleStyle = const TextStyle(color: LightColor.black,);

  static TextStyle bodyStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: LightColor.black,
  );
  static TextStyle body2Style = const TextStyle(
    fontSize: 16,
    color: LightColor.lightGrey,
  );
  
  static TextStyle captionStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: LightColor.black,
  );
}
