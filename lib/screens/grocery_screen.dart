import 'package:flutter/material.dart';

class GroceryScreen extends StatelessWidget {
  GroceryScreen({super.key});

  final List<String> groceries = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groceries.length,
      itemBuilder: (context, index) => Text(""),
    );
  }
}
