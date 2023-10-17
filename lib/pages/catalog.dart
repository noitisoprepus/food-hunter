import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hunter/helper.dart';
import 'package:food_hunter/pages/food.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Map<String, dynamic> _foodsData = {};
  late List<String> _foodsDataKeys = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFoodsData();
  }

  Future<void> _loadFoodsData() async {
    final String response = await rootBundle.loadString('assets/foods.json');
    setState(() {
      _foodsData = jsonDecode(response);
      _foodsDataKeys = _foodsData.keys.toList();
    });
  }

  List<String> _getFilteredFoodKeys() {
    return _foodsData.keys
        .where((foodName) => foodName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
        ..sort();
  }

  @override
  Widget build(BuildContext context) {
    List<String> foodsKeys = _getFilteredFoodKeys();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Material(
              elevation: 10,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.all(16.0),
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: foodsKeys.length,
                itemBuilder: (BuildContext context, int index) {
                  final String foodKey = foodsKeys[index];
                  return _buildGridItem(context, index, foodKey);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index, String key) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodPage(itemKey: key, itemData: _foodsData[key],),
          ),
        );
      },
      child: Hero(
        tag: key,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
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
                    child: Text(
                      _foodsData[key]['iconName'],
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[100],
                        height: 1.2,
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
    );
  }
}
