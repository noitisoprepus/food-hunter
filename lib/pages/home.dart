import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedInformationIndex = 0; // Track the currently selected information entry

  final List<String> informationEntries = [
    'Food preservation info 1',
    'Food preservation info 2',
    'Food preservation info 3',
    // Add more information entries here
  ];

  final List<String> seasonalFoods = [
    'Food A',
    'Food B',
    'Food C',
    'Food D',
    'Food E'
  ];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    // Listen for page changes and update selectedInformationIndex
    _pageController.addListener(() {
      setState(() {
        selectedInformationIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align elements at the start and end of the row
              children: [
                Text(
                  'FOOD HUNTER', // Replace with your desired title text
                  style: TextStyle(
                    fontSize: 24, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Adjust the font weight as needed
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 24.0, // Adjust the icon size as needed
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.all(16.0), // Adjust margin as needed
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10.0), // Border radius of 10
          //     border: Border.all(
          //       color: Colors.grey, // Border color
          //       width: 1.0, // Border width
          //     ),
          //   ),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: 'Search',
          //       hintStyle: TextStyle(color: Colors.grey),
          //       contentPadding: EdgeInsets.all(16.0), // Adjust padding as needed
          //       prefixIcon: Icon(Icons.search), // Magnifying glass icon
          //       border: InputBorder.none, // Remove the default underline
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 24
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 120,
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: Colors.blue, // Change to your preferred background color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Featured banner',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Change text color as needed
                    )
                  )
                )
              )
            )
          ),
          SizedBox(
            height: 24,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                  'FOODS IN SEASON',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              )
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding for the entire ListView
            child: SizedBox(
              height: 120, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: seasonalFoods.length,
                itemBuilder: (BuildContext context, int index) {
                  // Add spacing between items
                  return Row(
                    children: [
                      Container(
                        width: 120, // Adjust the width as needed
                        decoration: BoxDecoration(
                          color: Colors.blue, // Change to your preferred background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            seasonalFoods[index],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white, // Change text color as needed
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0), // Add horizontal spacing between items
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                  'WHY PRESERVE FOOD?',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              )
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 220, // Adjust the height as needed
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: informationEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Container(
                        width: 355, // Adjust the width as needed
                        decoration: BoxDecoration(
                          color: Colors.blue, // Change to your preferred background color
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            informationEntries[index],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white, // Change text color as needed
                            ),
                          ),
                        ),
                      ),
                    ]
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              informationEntries.length,
              (index) => Container(
                width: 12,
                height: 12,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == selectedInformationIndex
                      ? Colors.red // Highlight the selected circle
                      : Colors.grey, // Default color for other circles
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          ElevatedButton(
            onPressed: () {
              // Add navigation to the catalog page here
              // Navigator.push(context, MaterialPageRoute(builder: (context) => CatalogPage()));
            },
            child: Text(
              'Browse Foods',
              style: TextStyle(
                fontSize: 16
              ),
            ),
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