import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hunter/helper.dart';
import 'package:food_hunter/pages/catalog.dart';
import 'package:food_hunter/pages/food.dart';
import 'package:food_hunter/themes/color_scheme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedInformationIndex = 0;

  late Map<String, dynamic> _foodsData = {};
  late Map<String, dynamic> _preservationData = {};
  late List<String> _seasonalFoods = [];
  late List<String> _preservationDataKeys = [];

  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  bool isBannerHovered = false;
  List<bool> isSeasonalHovered = [];

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

    List<String> seasonalFoods = [];

    foodsDataMap.forEach((key, value) {
      List<dynamic> seasons = value['season'];
      if (seasons.contains(currMonth)) {
        seasonalFoods.add(key);
      }
    });
    seasonalFoods.sort();
    setState(() {
      _seasonalFoods = seasonalFoods;
    });

    isSeasonalHovered = List.filled(_seasonalFoods.length, false);
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
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 12.0),
              child: Row(
                children: [
                  Image(
                    image: AssetImage('assets/pics/logo/icon.png'),
                    height: 36,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "FOOD HUNTER",
                    style: TextStyle(
                        fontFamily: 'Lato-Black',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: FHColorScheme.primaryColor
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: screenHeight * ((screenHeight > 900) ? 0.165 : (screenHeight > 800) ? 0.155 : 0.14),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CatalogPage(),
                      ),
                    );
                  },
                  onHover: (value) {
                    setState(() {
                      isBannerHovered = value;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    transform: Matrix4.identity()..translate(0.0, isBannerHovered ? -2.5 : 0.0),
                    decoration: BoxDecoration(
                      color: FHColorScheme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10.0,
                        ),
                      ],
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
                            style: TextStyle(
                              fontFamily: 'Lato-Black',
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
                    '${currMonth.toUpperCase()} PRODUCE',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.primaryColor
                    ),
                  )
                )
            ),
            SizedBox(
              height: screenHeight * 0.25,
              child: Stack(
                children: [
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      _scrollController.jumpTo(_scrollController.offset - details.primaryDelta! / 2);
                    },
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _seasonalFoods.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isFirst = index == 0;
                        bool isLast = index == (_seasonalFoods.length - 1);
                        
                        return Padding(
                          padding: EdgeInsets.only(left: isFirst ? 16.0 : 8.0, right: isLast ? 16.0 : 8.0, top: 16.0, bottom: 16.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FoodPage(itemKey: _seasonalFoods[index], itemData: _foodsData[_seasonalFoods[index]],),
                                ),
                              );
                            },
                            onHover: (value) {
                              setState(() {
                                isSeasonalHovered[index] = value;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              transform: Matrix4.identity()..translate(0.0, isSeasonalHovered[index] ? -2.5 : 0.0),
                              width: 170,
                              decoration: BoxDecoration(
                                color: FHColorScheme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 10.0,
                                  ),
                                ],
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
                                        child: FittedBox(
                                          child: Text(
                                            _foodsData[_seasonalFoods[index]]['iconName']
                                              .replaceAll(' ', '\n'),
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[100],
                                              height: 1.0,
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
                                  ),
                                ]
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Positioned(
                  //   left: 4,
                  //   top: (screenHeight * 0.25 - 2 * 8 - 24) / 2,
                  //   child: Visibility(
                  //     visible: Platform.isWindows || Platform.isLinux || Platform.isMacOS,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         color: Colors.white.withOpacity(0.65),
                  //         borderRadius: BorderRadius.circular(24),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.black.withOpacity(0.2),
                  //             spreadRadius: 2,
                  //             blurRadius: 4,
                  //             offset: const Offset(0, 2),
                  //           ),
                  //         ],
                  //       ),
                  //       child: IconButton(
                  //         icon: const Icon(Icons.arrow_back),
                  //         color: Colors.black.withOpacity(0.65),
                  //         onPressed: () {
                  //           _scrollController.animateTo(
                  //             _scrollController.offset - 250,
                  //             duration: const Duration(milliseconds: 500),
                  //             curve: Curves.easeInOut,
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   right: 4,
                  //   top: (screenHeight * 0.25 - 2 * 8 - 24) / 2,
                  //   child: Visibility(
                  //     visible: Platform.isWindows || Platform.isLinux || Platform.isMacOS,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         color: Colors.white.withOpacity(0.65),
                  //         borderRadius: BorderRadius.circular(24),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.black.withOpacity(0.2),
                  //             spreadRadius: 2,
                  //             blurRadius: 4,
                  //             offset: const Offset(0, 2),
                  //           ),
                  //         ],
                  //       ),
                  //       child: IconButton(
                  //         icon: const Icon(Icons.arrow_forward),
                  //         color: Colors.black.withOpacity(0.65),
                  //         onPressed: () {
                  //           _scrollController.animateTo(
                  //             _scrollController.offset + 250,
                  //             duration: const Duration(milliseconds: 500),
                  //             curve: Curves.easeInOut,
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                    'WHY PRESERVE FOOD?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.primaryColor
                    ),
                  )
                )
            ),
            SizedBox(
              height: screenHeight * ((screenHeight > 900) ? 0.4 : (screenHeight > 800) ? 0.375 : 0.35),
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (details.primaryDelta! > 0) {
                    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  } else if (details.primaryDelta! < 0) {
                    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  }
                },
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _preservationData.length,
                  itemBuilder: (BuildContext context, int index) {
                    String imgPath = _preservationData[_preservationDataKeys[index]]['img'];
                    String infoText = _preservationData[_preservationDataKeys[index]]['info'];
                    String descrText = _preservationData[_preservationDataKeys[index]]['description'];
                            
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                      child: Container(
                        width: screenWidth - 32,
                        decoration: BoxDecoration(
                          color: FHColorScheme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 10.0,
                            ),
                          ],
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
                                    style: TextStyle(
                                      fontFamily: 'Lato-Black',
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
                                    style: TextStyle(
                                      fontFamily: 'Lato',
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
                    );
                  },
                ),
              ),
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