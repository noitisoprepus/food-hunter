import 'package:flutter/material.dart';
import 'package:food_hunter/pages/splash_screen.dart';
import 'package:food_hunter/themes/color_scheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: FHColorScheme.colorSchemeLight,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Food Hunter',
      home: const SplashScreen(),
    );
  }
}
