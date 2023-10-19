import 'package:flutter/material.dart';
import 'package:food_hunter/pages/home.dart';
import 'package:food_hunter/themes/color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: FHColorScheme.colorSchemeLight,
        textTheme: GoogleFonts.latoTextTheme()
      ),
      debugShowCheckedModeBanner: false,
      title: 'Food Hunter',
      home: const HomePage(),
    );
  }
}
