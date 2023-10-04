import 'package:flutter/material.dart';
import 'package:mobiletourguide/screens/AddNewPlaces.dart';
import 'package:mobiletourguide/screens/DisplayPlaces.dart';
//import 'package:mobiletourguide/screens/UserLocation/userLocation.dart';
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: AppBar(
            title: const Text("Home"),
            centerTitle: true,
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 1,
                ),
                child: const Icon(Icons.logout),
              )
            ],
            flexibleSpace: Container(
              child: const Header(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //const Header(),
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
                          'Popular Destinations',
                          style: TextStyle(
                            fontSize: 18,
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
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height:
                        200, // Set the height for your horizontal scrollable section
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('places')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          final List<Widget> favoriteDestinations = [];

                          for (final DocumentSnapshot documentSnapshot
                              in streamSnapshot.data!.docs) {
                            final String imageUrl = documentSnapshot[
                                'mainImageUrl']; // Extract imageUrl
                            final String name =
                                documentSnapshot['name']; // Extract name
                            final String placeId =
                                documentSnapshot.id; // Get the document ID

                            favoriteDestinations.add(
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the details page when a box is tapped.
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PlaceDetailsPage(
                                        placeId: placeId,
                                        imageUrl: imageUrl,
                                        name: name,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    width: 150,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Color(0xffd9d9d9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          width: 140,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(imageUrl),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(name),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: favoriteDestinations,
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
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceDetailsPage extends StatelessWidget {
  final String placeId;
  final String imageUrl;
  final String name;

  const PlaceDetailsPage(
      {required this.placeId,
      required this.imageUrl,
      required this.name,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: AppBar(
          title: null, // Remove the title
          centerTitle: true,
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Overlayed name text
              Positioned(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.5), // Semi-transparent background
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name, // Display the name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('places').doc(placeId).get(),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Center-align the content
                      children: <Widget>[
                        SizedBox(height: 16.0),
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
