import 'package:flutter/material.dart';
import 'package:food_hunter/helper.dart';
import 'package:food_hunter/pages/preservation.dart';
import 'package:food_hunter/themes/color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class FoodPage extends StatefulWidget {
  final String itemKey;
  final Map<String, dynamic> itemData;

  const FoodPage({Key? key, required this.itemKey, required this.itemData}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
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
    Map<String, dynamic> preservation = foodData['preservation'] as Map<String, dynamic>;
    List<String> preservationKeys = preservation.keys.toList();
    List<String> seasonsList = List<String>.from(foodData['season']);
    String key = widget.itemKey;

    nutrients.remove('src');

    String seasons = '';
    for (int i = 0; i < seasonsList.length; i++) {
      seasons += seasonsList[i];
      if (i == (seasonsList.length - 1)) {
        break;
      }
      seasons += ', ';
    }
    String seasonsText = (seasons == '') ? "Available year-round" : seasons;

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
                    tag: key,
                    child: Material(
                      elevation: 10,
                      child: Image(
                        image: AssetImage('assets/pics/foods/$key.jpg'),
                        width: screenWidth,
                        fit: BoxFit.cover,
                      ),
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
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.secondaryColor
                    )
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    foodData['binomial'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    )
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    foodData['type'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: FHColorScheme.primaryColor
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Season: $seasonsText',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                    'PRESERVATION METHODS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.secondaryColor
                    ),
                  )
                )
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: preservationKeys.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isFirst = index == 0;
                    bool isLast = index == (preservationKeys.length - 1);
      
                    return Row(
                      children: [
                        SizedBox(width: isFirst ? 16.0 : 8.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreservationPage(itemKey: key, preservationKey: preservationKeys[index], preservationData: preservation),
                              ),
                            );
                          },
                          child: Hero(
                            tag: '${key}_${preservationKeys[index]}',
                            child: Container(
                              width: 180,
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
                                      image: AssetImage('assets/pics/foods/preservation/${key}_${preservationKeys[index]}.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
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
                                  Material(
                                    type: MaterialType.transparency,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          preservation[preservationKeys[index]]['name'],
                                          style: GoogleFonts.hindSiliguri(
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
                                ]
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
                height: 20,
              ),
              const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                    'HEALTH BENEFITS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FHColorScheme.secondaryColor
                    ),
                  )
                )
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nutrient')),
                      DataColumn(label: Text('Amount')),
                    ],
                    rows: [
                      for (var nutrientEntry in nutrients.entries)
                        buildDataRow(nutrientEntry.key, nutrientEntry.value.toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Link(
              //       uri: Uri.parse(foodData['nutrients']['src']),
              //       builder: (context, followLink) {
              //         return GestureDetector(
              //           onTap: followLink,
              //           child: const Text(
              //             'Source',
              //             style: TextStyle(
              //               fontSize: 18,
              //               color: Colors.blue,
              //               decoration: TextDecoration.underline,
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              )
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

  DataRow buildDataRow(String nutrient, String amount) {
    return DataRow(
      cells: [
        DataCell(Text(nutrient)),
        DataCell(Text(amount)),
      ],
    );
  }
}
