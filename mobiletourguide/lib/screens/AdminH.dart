import 'package:flutter/material.dart';
import 'package:mobiletourguide/screens/AddNewPlaces.dart';


class AdminH extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdminProfilePage(),
    );
  }
}

class AdminProfilePage extends StatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  // Sample user data
  String username = "Admin";
  String email = "admin@example.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              // Load the user's profile picture from Firebase Storage or a URL
              backgroundImage: AssetImage('assets/images/avater.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Username: $username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Email: $email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewPlaces(),
                  ),
                );
              },
              child: Text('Add New Places'),
            ),
          ],
        ),
      ),
    );
  }
}
