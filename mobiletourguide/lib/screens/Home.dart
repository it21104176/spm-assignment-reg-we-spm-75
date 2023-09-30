import 'package:flutter/material.dart';
import 'package:mobiletourguide/screens/AddNewPlaces.dart';
import 'package:mobiletourguide/screens/DisplayPlaces.dart';
//import 'package:mobiletourguide/screens/UserLocation/userLocation.dart';
//import 'package:mobiletourguide/screens/pointOfinterest/InterestPlace.dart';
import 'package:mobiletourguide/widgets/featuredCategories.dart';
import 'package:mobiletourguide/widgets/header.dart';
import 'package:mobiletourguide/widgets/search.dart';
import '../constants/colors.dart';
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
                const Header(),
                const SizedBox(height: 10),
                const Search(),
                const SizedBox(height: 10),
                const FeaturedCategories(),
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
                    stream: FirebaseFirestore.instance
                        .collection('places')
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                            2, // You can adjust the number of columns as per your preference
                          ),
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                            final String imageUrl = documentSnapshot[
                                'mainImageUrl']; // Extract imageUrl
                            final String name =
                            documentSnapshot['name']; // Extract name
                            final String placeId =
                                documentSnapshot.id; // Get the document ID

                            return GestureDetector(
                              onTap: () {
                                // Navigate to the details page when a box is tapped.
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlaceDetailsPage(placeId: placeId),
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
                                      alignment:
                                      Alignment.center, // Center the image.
                                      child: Image.network(
                                        // Use Image.network to load the image from URL
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
                ),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: FloatingActionButton(
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => LocationPage(),
            //           ),
            //         );
            //       },
            //       child: const Icon(Icons.my_location),
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => InterestPlace(),
            //           ),
            //         );
            //       },
            //       child: const Text('Point of Interest'),
            //     ),
            //   ),
            // ),
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
        future: FirebaseFirestore.instance.collection('places')
            .doc(placeId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Place not found'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final String imageUrl = data['mainImageUrl'];
            final String name = data['name'];
            final String description = data['description'];
            final List<dynamic> visitedPlaces = data['visitedplaces'];
            final List<dynamic> services = data['services'];
            final List<dynamic> additionalImageUrls =
                data['additionalImageUrls'];

            return Column(
              // Wrap the Column in Center
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Center-align the content
                      children: <Widget>[
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
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        // Display the description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        // Display the services
                        const Text(
                          'More Services  ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        for (var service in services)
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 4.0),
                                Expanded(
                                  child: Text(
                                    service,
                                    style: TextStyle(fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 12.0),
                        // Display the visiting places
                        const Text(
                          'Places to visit  ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        for (var visitedplace in visitedPlaces)
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 4.0),
                                Expanded(
                                  child: Text(
                                    visitedplace,
                                    style: TextStyle(fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 16.0),
                        // Display the description
                        const Text(
                          'More Images',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        for (var additionalimageurls in additionalImageUrls)
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 4.0),
                                Expanded(
                                  child: Image.network(
                                    additionalimageurls,
                                    height: 200.0,
                                    width: 400.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}