import 'package:flutter/material.dart';
import '../../services/authservice.dart';
import 'package:mobiletourguide/screens/user_profile/user_profile_screen.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // create a object from AuthService
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UserProfile(),
                    ),
                );
              },
              child: const Icon(Icons.logout),
            )
          ],
        ),
      ),
    );
  }
}
