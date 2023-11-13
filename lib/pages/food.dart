import 'package:flutter/material.dart';
import 'package:food_hunter/helper.dart';
import 'package:food_hunter/pages/preservation.dart';
import 'package:food_hunter/themes/color_scheme.dart';
import 'package:url_launcher/link.dart';

class FoodPage extends StatefulWidget {
  final String itemKey;
  final Map<String, dynamic> itemData;

  const FoodPage({Key? key, required this.itemKey, required this.itemData}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final ScrollController _scrollController = ScrollController();

  List<bool> isMethodHovered = [];
  bool cheat = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, dynamic> foodData = widget.itemData;
    Map<String, dynamic> nutrients = Map.from(foodData['nutrients'] as Map<String, dynamic>);
    Map<String, dynamic> preservation = foodData['preservation'] as Map<String, dynamic>;
    List<String> preservationKeys = preservation.keys.toList();
    List<String> seasonsList = List<String>.from(foodData['season']);
    String key = widget.itemKey;
    String nutrientsSrc = foodData['nutrients']['src'] ?? '';
    nutrients.remove('src');

    if (!cheat) {
      isMethodHovered = List.filled(preservationKeys.length, false);
      cheat = true;
    }

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
      appBar: AppBar(
        title: const Text(
          'FOOD INFO'
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 500
                ),
                child: Hero(
                  tag: key,
                  child: Material(
                    elevation: 10,
                    child: Image(
                      image: AssetImage('assets/pics/foods/$key.jpg'),
                      fit: BoxFit.contain,
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
              SizedBox(
                height: screenHeight * 0.25,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    _scrollController.jumpTo(_scrollController.offset - details.primaryDelta! / 2);
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: preservationKeys.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isFirst = index == 0;
                      bool isLast = index == (preservationKeys.length - 1);
                      
                      return Padding(
                        padding: EdgeInsets.only(left: isFirst ? 16.0 : 8.0, right: isLast ? 16.0 : 8.0, top: 16.0, bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreservationPage(itemKey: key, preservationKey: preservationKeys[index], preservationData: preservation),
                              ),
                            );
                          },
                          onHover: (value) {
                            setState(() {
                              isMethodHovered[index] = value;
                            });
                          },
                          child: Hero(
                            tag: '${key}_${preservationKeys[index]}',
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              transform: Matrix4.identity()..translate(0.0, isMethodHovered[index] ? -2.5 : 0.0),
                              width: 170,
                              decoration: BoxDecoration(
                                color: FHColorScheme.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                BoxShadow(
                                  blurRadius: 5.0,
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
                                        child: FittedBox(
                                          child: Text(
                                            preservation[preservationKeys[index]]['name']
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
                        ),
                      );
                    },
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text(
                        'REFERENCES: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: FHColorScheme.secondaryColor,
                        ),
                      ),
                      Link(
                        uri: Uri.parse(nutrientsSrc),
                        builder: (context, followLink) {
                          return InkWell(
                            onTap: followLink,
                            child: const Text(
                              'Link',
                              style: TextStyle(
                                fontSize: 18,
                                color: FHColorScheme.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
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
