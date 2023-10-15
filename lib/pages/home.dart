import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hunter/pages/catalog.dart';
import 'package:food_hunter/pages/food.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedInformationIndex = 0;

  final List<String> informationEntries = [
    'Food preservation info 1',
    'Food preservation info 2',
    'Food preservation info 3',
    // Add more information entries here
  ];

  late Map<String, dynamic> _foodsData = {};
  late final List<String> _seasonalFoods = [];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadSeasonalFoods();
    _pageController.addListener(() {
      setState(() {
        selectedInformationIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  Future<void> _loadSeasonalFoods() async {
    DateTime now = DateTime.now();
    String currMonth = getMonthString(now.month);

    final String response = await rootBundle.loadString('assets/foods.json');
    Map<String, dynamic> foodsData = jsonDecode(response);
    setState(() {
      _foodsData = foodsData;
    });

    foodsData.forEach((key, value) {
      List<dynamic> seasons = value['season'];
      if (seasons.contains(currMonth)) {
        setState(() {
          _seasonalFoods.add(key);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String currMonth = getMonthString(now.month);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FOOD HUNTER',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 24.0,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 120,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Featured banner',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )
                    )
                  )
                )
              )
            ),
            const SizedBox(
              height: 24,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                    'SEASONAL PRODUCE ($currMonth)',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  )
                )
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _seasonalFoods.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isFirst = index == 0;
                  bool isLast = index == (_seasonalFoods.length - 1);
      
                  return Row(
                    children: [
                      SizedBox(width: isFirst ? 16.0 : 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodPage(itemKey: _seasonalFoods[index], itemData: _foodsData[_seasonalFoods[index]],),
                            ),
                          );
                        },
                        child: Hero(
                          tag: _seasonalFoods[index],
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                _foodsData[_seasonalFoods[index]]['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isLast ? 16.0 : 8.0),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Align(
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
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: informationEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: screenWidth - 32,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)
                          ),
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
                      )
                    ]
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                informationEntries.length,
                (index) => Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == selectedInformationIndex
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CatalogPage(),
                  ),
                );
              },
              child: const Text(
                'Browse Foods',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String getMonthString(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Invalid Month';
    }
  }
}