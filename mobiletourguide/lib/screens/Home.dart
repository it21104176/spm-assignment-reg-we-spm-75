import 'package:flutter/material.dart';
import 'package:mobiletourguide/screens/DisplayPlaces.dart';
import 'package:mobiletourguide/screens/UserLocation/userLocation.dart';
import 'package:mobiletourguide/screens/pointOfinterest/InterestPlace.dart';
import '../services/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Create an object from AuthService
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
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Explore the world with us!',
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
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Favorite destinations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DisplayPlaces(),
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
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('places').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // You can adjust the number of columns as per your preference
                          ),
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            final String imageUrl = documentSnapshot['imageUrl']; // Extract imageUrl
                            final String name = documentSnapshot['name']; // Extract name
                            final String placeId = documentSnapshot.id; // Get the document ID

                            return GestureDetector(
                              onTap: () {
                                // Navigate to the details page when a box is tapped.
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PlaceDetailsPage(placeId: placeId),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white38,
                                elevation: 4,
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 15),
                                    Container(
                                      alignment: Alignment.center, // Center the image.
                                      child: Image.network( // Use Image.network to load the image from URL
                                        imageUrl,
                                        height: 100, // Set the image height
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )
                ,
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LocationPage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InterestPlace(),
                      ),
                    );
                  },
                  child: const Text('Point of Interest'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PlaceDetailsPage extends StatelessWidget {
  final String placeId;

  const PlaceDetailsPage({required this.placeId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Details'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('places').doc(placeId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Place not found'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final String imageUrl = data['imageUrl'];
            final String name = data['name'];
            final String description = data['description'];
            final String visitedPlaces = data['visitedplaces'];
            final List<dynamic> services = data['services'];

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the image
                  Center(
                    child: Image.network(
                      imageUrl,
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Display the name
                  Text(
                    'Name:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 12.0),
                  // Display the description
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 12.0),
                  // Display the visiting places
                  Text(
                    'Visiting Places:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    visitedPlaces,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 12.0),
                  // Display the services
                  Text(
                    'Services:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  // Display the list of services with bullets
                  for (var service in services)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 16.0,
                        ),
                        SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            service,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
