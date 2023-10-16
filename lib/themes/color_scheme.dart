import 'package:flutter/material.dart';

class FHColorScheme {
  static const Color primaryColor = Color.fromRGBO(77, 144, 120, 1);
  static const Color secondaryColor = Color.fromRGBO(22, 37, 33, 1);
  static const Color tertiaryColor = Color.fromRGBO(221, 252, 173, 1);
  static const Color accentColor = Color.fromRGBO(152, 38, 73, 1);

  static const ColorScheme colorSchemeLight = ColorScheme(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light
  );
}
