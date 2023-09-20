import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        style: const TextStyle(fontSize: 16.0), // Adjust text style
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0), // Increase vertical padding
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search,
              color: Colors.grey), // Customize icon color
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(25.0), // Customize border radius
            borderSide:
                const BorderSide(color: Colors.grey), // Customize border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
                color: Colors.blue), // Customize focused border color
          ),
        ),
      ),
    );
  }
}
