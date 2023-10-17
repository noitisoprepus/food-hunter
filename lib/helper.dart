import 'package:flutter/material.dart';

class Helper {
  static ColorFilter darkenFilter = ColorFilter.mode(
    Colors.black.withOpacity(0.0),
    BlendMode.srcOver,
  );
  static Color textShadowCol = Colors.black.withOpacity(0.8);
  static Offset textShadowOffset = const Offset(3, 5);
  static double textShadowBlurRadius = 7.0;
}