import 'package:flutter/material.dart';
import 'package:food_hunter/themes/color_scheme.dart';

class PreservationPage extends StatefulWidget {
  final String itemKey;
  final String preservationKey;
  final Map<String, dynamic> preservationData;

  const PreservationPage({Key? key, required this.itemKey, required this.preservationKey, required this.preservationData}) : super(key: key);

  @override
  _PreservationPageState createState() => _PreservationPageState();
}

class _PreservationPageState extends State<PreservationPage> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic> foodData = widget.preservationData;
    Map<String, dynamic> nutrients = foodData['nutrients'] as Map<String, dynamic>;
    nutrients.remove('src');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  height: 220,
                  child: Hero(
                    tag: widget.preservationKey,
                    child: Container(
                      width: screenWidth,
                      decoration: const BoxDecoration(
                          color: FHColorScheme.primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    foodData['name'],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
