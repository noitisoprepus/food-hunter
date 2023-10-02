import 'package:flutter/material.dart';

class FoodPage extends StatefulWidget {
  final int itemIndex; // Define the itemIndex

  const FoodPage({Key? key, required this.itemIndex}) : super(key: key); // Update constructor

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final List<String> informationEntries = [
    'Picture 1',
    'Picture 2',
    'Picture 3',
    // Add more information entries here
  ];

  int selectedInformationIndex = 0; // Track the currently selected information entry
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Listen for page changes and update selectedInformationIndex
    _pageController.addListener(() {
      setState(() {
        selectedInformationIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Generate a dynamic title based on the itemIndex
    String itemTitle = 'Item ${widget.itemIndex}';

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(itemTitle), // Set the app bar title to the item name
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              height: 220, // Adjust the height as needed
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: informationEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Hero(
                        tag: 'food_item_${widget.itemIndex}',
                        child: Container(
                          width: screenWidth, // Adjust the width as needed
                          decoration: BoxDecoration(
                              color: Colors.blue), // Change to your preferred background color
                          child: Center(
                            child: Text(
                              informationEntries[index],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white, // Change text color as needed
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
