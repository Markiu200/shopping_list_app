import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget(this.item, {super.key});

  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 16,
        height: 16,
        child: DecoratedBox(
          decoration: BoxDecoration(color: item.category.color),
        ),
      ),
      title: Text(item.name),
      trailing: Text("${item.quantity}"),
    );
  }
}
