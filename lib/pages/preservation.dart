import 'package:flutter/material.dart';

class PreservationPage extends StatefulWidget {
  final String itemKey;
  final Map<String, dynamic> itemData;

  const PreservationPage({Key? key, required this.itemKey, required this.itemData}) : super(key: key);

  @override
  _PreservationPageState createState() => _PreservationPageState();
}

class _PreservationPageState extends State<PreservationPage> {
  final List<String> informationEntries = [
    'Picture 1',
    'Picture 2',
    'Picture 3',
    // Add more information entries here
  ];

  int selectedInformationIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageController.addListener(() {
      setState(() {
        selectedInformationIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic> foodData = widget.itemData;
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
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: informationEntries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Hero(
                            tag: widget.itemKey,
                            child: Container(
                              width: screenWidth,
                              decoration: const BoxDecoration(
                                  color: Colors.blue),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Center(
                                  child: Text(
                                    informationEntries[index],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
    _pageController.dispose();
    super.dispose();
  }
}
