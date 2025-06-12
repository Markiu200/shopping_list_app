import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/grocery_item_widget.dart';

class GroceryScreen extends StatelessWidget {
  GroceryScreen({super.key});

  final List<GroceryItem> groceries = groceryItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groceries.length,
      itemBuilder:
          (context, index) => GroceryItemWidget(
            groceryItems[index],
            key: ValueKey(groceryItems[index].id),
          ),
    );
  }
}
