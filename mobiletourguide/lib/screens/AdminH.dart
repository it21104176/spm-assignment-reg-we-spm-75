import 'package:flutter/material.dart';
import 'package:mobiletourguide/screens/AddNewPlaces.dart';
import 'package:mobiletourguide/screens/DisplayPlaces.dart';
//import 'package:mobiletourguide/screens/UserLocation/userLocation.dart';
//import 'package:mobiletourguide/screens/pointOfinterest/InterestPlace.dart';
import '../constants/colors.dart';
import '../services/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/header.dart';
import '../widgets/search.dart';

class AdminH extends StatefulWidget {
  const AdminH({super.key});

  @override
  State<AdminH> createState() => _AdminHState();
}

class _AdminHState extends State<AdminH> {
  // Create an object from AuthService
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Home"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Icon(Icons.logout),
            )
          ],
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                const SizedBox(height: 10),
                const Search(),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
