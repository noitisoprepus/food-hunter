import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hunter/helper.dart';
import 'package:food_hunter/pages/catalog.dart';
import 'package:food_hunter/pages/food.dart';
import 'package:food_hunter/themes/color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedInformationIndex = 0;

  late Map<String, dynamic> _foodsData = {};
  late Map<String, dynamic> _preservationData = {};
  late final List<String> _seasonalFoods = [];
  late List<String> _preservationDataKeys = [];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadSeasonalFoods();
    _loadPreservationInfo();
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
    Map<String, dynamic> foodsDataMap = jsonDecode(response);
    setState(() {
      _foodsData = foodsDataMap;
    });

    foodsDataMap.forEach((key, value) {
      List<dynamic> seasons = value['season'];
      if (seasons.contains(currMonth)) {
        setState(() {
          _seasonalFoods.add(key);
        });
      }
    });
  }

  Future<void> _loadPreservationInfo() async {
    final String response = await rootBundle.loadString('assets/preservation.json');
    Map<String, dynamic> preservationInfoMap = jsonDecode(response);
    setState(() {
      _preservationData = preservationInfoMap['homeInfo'];
      _preservationDataKeys = _preservationData.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();
    String currMonth = getMonthString(now.month);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Image(
                    image: AssetImage('assets/pics/logo/banner-logo.png'),
                    height: 36,
                  ),
                  Icon(
                    Icons.info,
                    color: Colors.blue[600],
                    size: 28.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: screenHeight * 0.15,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CatalogPage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: FHColorScheme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        ColorFiltered(
                          colorFilter: Helper.darkenFilter,
                          child: const Image(
                            image: AssetImage('assets/pics/preservation/market_0.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'BROWSE FOODS',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[100],
                              shadows: [
                                Shadow(
                                  color: Helper.textShadowCol,
                                  offset: Helper.textShadowOffset,
                                  blurRadius: 5,
                                )
                              ]
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    'SEASONAL PRODUCE (${currMonth.toUpperCase()})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.primaryColor
                    ),
                  )
                )
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 150,
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
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: FHColorScheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ColorFiltered(
                                colorFilter: Helper.darkenFilter,
                                child: Image(
                                  image: AssetImage('assets/pics/foods/${_seasonalFoods[index]}.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.0),
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      _foodsData[_seasonalFoods[index]]['iconName'],
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[100],
                                        height: 1,
                                        shadows: [
                                          Shadow(
                                            color: Helper.textShadowCol,
                                            offset: Helper.textShadowOffset,
                                            blurRadius: Helper.textShadowBlurRadius
                                          )
                                        ]
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.primaryColor
                    ),
                  )
                )
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: screenHeight * 0.325,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: _preservationData.length,
                itemBuilder: (BuildContext context, int index) {
                  String imgPath = _preservationData[_preservationDataKeys[index]]['img'];
                  String infoText = _preservationData[_preservationDataKeys[index]]['info'];
                  String descrText = _preservationData[_preservationDataKeys[index]]['description'];

                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: screenWidth - 32,
                          decoration: BoxDecoration(
                            color: FHColorScheme.primaryColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              ColorFiltered(
                                colorFilter: Helper.darkenFilter,
                                child: Image(
                                  image: AssetImage(imgPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: screenWidth - 32,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.0),
                                      Colors.black.withOpacity(0.95),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      infoText,
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[100],
                                        shadows: [
                                          Shadow(
                                            color: Helper.textShadowCol,
                                            offset: Helper.textShadowOffset,
                                            blurRadius: Helper.textShadowBlurRadius
                                          )
                                        ]
                                      ),
                                    ),
                                    Text(
                                      descrText,
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                        color: Colors.grey[200],
                                        shadows: [
                                          Shadow(
                                            color: Helper.textShadowCol,
                                            offset: Helper.textShadowOffset,
                                            blurRadius: Helper.textShadowBlurRadius
                                          )
                                        ]
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                            ]
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
                _preservationData.length,
                (index) => Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == selectedInformationIndex
                        ? FHColorScheme.primaryColor
                        : Colors.grey[400],
                  ),
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