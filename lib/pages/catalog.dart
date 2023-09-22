import 'package:flutter/material.dart';
import 'package:food_hunter/pages/food.dart';

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Catalog'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: TextField(
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
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16.0, // Horizontal spacing between grid items
                mainAxisSpacing: 16.0, // Vertical spacing between grid items
              ),
              itemCount: 12, // Number of grid items
              padding: EdgeInsets.symmetric(horizontal: 8.0), // Padding around the grid
              itemBuilder: (BuildContext context, int index) {
                // Wrap each grid item with a ListTile
                return ListTile(
                  onTap: () {
                    // Navigate to the FoodPage when item is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodPage(itemIndex: index),
                      ),
                    );
                  },
                  title: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue, // Change to your preferred background color
                      borderRadius: BorderRadius.circular(10.0), // Border radius of each box
                    ),
                    child: Center(
                      child: Text(
                        'Item $index',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18.0, // Text font size
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}