import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hunter/pages/food.dart';

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late Future<Map<String, dynamic>> _foodsData;

  @override
  void initState() {
    super.initState();
    _foodsData = _loadFoodsData();
  }

  Future<Map<String, dynamic>> _loadFoodsData() async {
    final String response = await rootBundle.loadString('assets/foods.json');
    return jsonDecode(response);
  }

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Catalog'),
      ),
      body: Column(
        children: [
          Container(
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
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.all(16.0),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _foodsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading data: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available.'));
                } else {
                  Map<String, dynamic> _foodsData = snapshot.data!;
                  List<String> _foodsKeys = _foodsData.keys
                      .where((foodName) => foodName.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();

                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _foodsKeys.length,
                    itemBuilder: (BuildContext context, int index) {
                      final food = _foodsData[_foodsKeys[index]];
                      final String foodName = food['name'];
                      return _buildGridItem(context, index, foodName);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodPage(itemIndex: index, itemName: text),
          ),
        );
      },
      child: Hero(
        tag: text,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
