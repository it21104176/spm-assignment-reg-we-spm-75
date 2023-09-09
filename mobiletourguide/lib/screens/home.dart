import 'package:flutter/material.dart';
import 'package:mobiletourguide/screens/PlacesListPage.dart';
import 'package:mobiletourguide/screens/wrapper.dart';
import '../services/authservice.dart';

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
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Icon(Icons.logout),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Explore the world with us !',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0), // Add padding around the entire Row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Favorite destinations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // Top left
                  GestureDetector(
                    onTap: () {
                      // Navigate to the SeeAllPage when "See All" is pressed
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlacesListPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns per row
                  childAspectRatio: 1.0, // Aspect ratio of each grid item
                  mainAxisSpacing: 16.0, // Vertical spacing between rows
                  crossAxisSpacing: 16.0, // Horizontal spacing between columns
                ),
                itemCount: 4, // Replace with the number of items you want to display
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0), // Add padding around the image
                    child: Column(
                      children: [
                        Image.asset(

                          'assets/images/Mirissa.jpeg', // Replace with the image URL
 

                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8), // Adjust the spacing between the image and text
                        Text(
                          'Image Topic $index', // Replace with your image topic
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
