import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Card(
        elevation: 3, // You can adjust the elevation here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0), // Customize border radius
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: TextField(
            style: TextStyle(fontSize: 16.0), // Adjust text style
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0), // Increase vertical padding
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search,
                  color: Colors.grey), // Customize icon color
              border: InputBorder.none, // Remove the default border
              focusedBorder: InputBorder.none, // Remove the focused border
            ),
          ),
        ),
      ),
    );
  }
}
