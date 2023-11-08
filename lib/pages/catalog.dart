import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hunter/helper.dart';
import 'package:food_hunter/pages/food.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Map<String, dynamic> _foodsData = {};
  
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';

  List<bool> isFoodsHovered = [];

  @override
  void initState() {
    super.initState();
    _loadFoodsData();
  }

  Future<void> _loadFoodsData() async {
    final String response = await rootBundle.loadString('assets/foods.json');
    setState(() {
      _foodsData = jsonDecode(response);
    });
    isFoodsHovered = List.filled(_foodsData.length, false);
  }

  List<String> _getFilteredFoodKeys() {
    return _foodsData.keys
        .where((foodName) => foodName.toLowerCase().startsWith(_searchQuery.toLowerCase()))
        .toList()
        ..sort();
  }

  @override
  Widget build(BuildContext context) {
    List<String> foodsKeys = _getFilteredFoodKeys();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FOOD CATALOG",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Material(
              elevation: 10,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.8,
                      ),
                    ),
                    child: TextField(
                      onChanged: (query) {
                        EasyDebounce.debounce(
                          'search-debounce',
                          const Duration(milliseconds: 500),
                          () => setState(() {
                              _searchQuery = query;
                            })
                        );
                        
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                        contentPadding: EdgeInsets.all(16.0),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  _scrollController.jumpTo(_scrollController.offset - details.primaryDelta! / 2);
                },
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 256,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: foodsKeys.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String foodKey = foodsKeys[index];
                    return _buildGridItem(context, index, foodKey);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index, String key) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodPage(itemKey: key, itemData: _foodsData[key],),
          ),
        );
      },
      onHover: (value) {
        setState(() {
          isFoodsHovered[index] = value;
        });
      },
      child: Hero(
        tag: key,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()..translate(0.0, isFoodsHovered[index] ? -2.5 : 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
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
                  image: AssetImage('assets/pics/foods/$key.jpg'),
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
                        _foodsData[key]['iconName']
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
  }
}
