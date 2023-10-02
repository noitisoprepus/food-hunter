import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hunter/pages/food.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {

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
            child: const TextField(
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
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                _buildGridItem(context, 0, 'He\'d have you all unravel at the'),
                _buildGridItem(context, 1, 'Heed not the rabble'),
                _buildGridItem(context, 2, 'Sound of screams but the'),
                _buildGridItem(context, 3, 'Who scream'),
                _buildGridItem(context, 4, 'Revolution is coming...'),
                _buildGridItem(context, 5, 'Revolution, they...'),
                _buildGridItem(context, 6, 'Revolution, they...'),
                _buildGridItem(context, 7, 'Revolution, they...'),
                _buildGridItem(context, 8, 'Revolution, they...'),
                _buildGridItem(context, 9, 'Revolution, they...'),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index, String text) {
    return GestureDetector(
      onTap: () {
        // Navigate to the FoodPage when item is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodPage(itemIndex: index),
          ),
        );
      },
      child: Hero(
        tag: 'food_item_$index',
        child: Container(
          padding: const EdgeInsets.all(8),
          // color: Colors.teal[100 * (index + 1)],
          decoration: BoxDecoration(
            color: Colors.blue, // Change to your preferred background color
            borderRadius: BorderRadius.circular(10.0), // Border radius of each box
          ),
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }

  Future<void> readJson() async {
      final String response = await rootBundle.loadString('assets/foods.json');
      Map<String, dynamic> foods = jsonDecode(response);
  }
}