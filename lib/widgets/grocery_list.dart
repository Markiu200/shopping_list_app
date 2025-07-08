import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'flutter-prep-f6013-default-rtdb.europe-west1.firebasedatabase.app',
      'shopping-list.json',
    );
    final response = await http.get(url);
    // response:
    // {
    // "-OT7Y6-LDjFqhFLwCqyc":{"category":"Vegetables","name":"fhgh","quantity":5},
    // "-OUd4y3Mn0qJrNCddnBP":{"category":"Dairy","name":"jeffs","quantity":1},
    // "-OUd9pC70eJtnQHJx3qM":{"category":"Fruit","name":"bananas","quantity":12}
    // }
    //
    // Map<String, Map<String, dynamic>> is bit too much for Flutter (too specific),
    // thus replacing with just Map<String, dynamic>
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category =
          categories.entries
              .firstWhere(
                (catItem) => catItem.value.name == item.value['category'],
              )
              .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      // In case you have just backed out with device back button
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder:
            (ctx, index) => Dismissible(
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) {
                _removeItem(_groceryItems[index]);
              },
              child: ListTile(
                title: Text(_groceryItems[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text("${_groceryItems[index].quantity}"),
              ),
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
