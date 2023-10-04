import 'package:flutter/material.dart';
import 'package:mobiletourguide/constants/colors.dart';
import 'package:mobiletourguide/screens/pointOfinterest/InterestPlace.dart';
import '../screens/home.dart';
import '../screens/map.dart';
import '../screens/planner/planner.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key, required this.initialIndex}) : super(key: key);

  final int initialIndex;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex =
      0; // Use a non-final variable to store the selected index

  final List<Widget> _screens = [
    const Home(),
    const Map(),
    const InterestPlace(),
    const Planner(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.initialIndex; // Initialize with the provided initial index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (newIndex) {
          setState(() {
            // Update the selected index when a tab is tapped
            _selectedIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Interest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Planner',
          ),
        ],
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
