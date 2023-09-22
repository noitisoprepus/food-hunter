import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  final int itemIndex; // Define the itemIndex

  FoodPage({Key? key, required this.itemIndex}) : super(key: key); // Update constructor

  @override
  Widget build(BuildContext context) {
    // Generate a dynamic title based on the itemIndex
    String itemTitle = 'Item $itemIndex';

    return Scaffold(
      appBar: AppBar(
        title: Text(itemTitle), // Set the app bar title to the item name
      ),
      body: Center(
        child: Text('Food Details for $itemTitle'), // Use the dynamic item name
      ),
    );
  }
}
