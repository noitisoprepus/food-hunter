import 'package:flutter/material.dart';
import 'package:food_hunter/pages/home.dart';

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
        colorScheme: const ColorScheme.light(primary: Colors.red),
        fontFamily: 'Roboto'
      ),
      debugShowCheckedModeBanner: false,
      title: 'Food Hunter',
      home: HomePage()
    );
  }
}
