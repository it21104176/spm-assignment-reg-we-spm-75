import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobiletourguide/screens/AddNewPlaces.dart';
import 'package:mobiletourguide/screens/AdminH.dart';
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
            flexibleSpace: const Header(),
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
                                builder: (context) => AdminH(),
                              ),
                            );
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              fontSize: 14,
                              color: primary,
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
                            final String imageUrl = documentSnapshot['mainImageUrl']; // Extract imageUrl
                            final String name = documentSnapshot['name']; // Extract name
                            final String placeId = documentSnapshot.id; // Get the document ID

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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          width: 140,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(imageUrl),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              // Add your rating stars widget here
                                              // For example, if you are using the Flutter 'flutter_rating_bar' package:
                                              RatingBar.builder(
                                                initialRating: 4, // Replace with your rating value
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemSize: 16, // Adjust the size of the rating stars
                                                itemCount: 5,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  // Handle the rating update if needed
                                                },
                                              ),
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

  const PlaceDetailsPage({
    required this.placeId,
    required this.imageUrl,
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image (simulating the AppBar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 250, // Set the height you want for the "AppBar"
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0, left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop(); // Navigate back
                    },
                  ),
                ),
              ),
            ),
          ),
          // Card component
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('places')
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
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final String description = data['description'];
                      final List<dynamic> visitedPlaces = data['visitedplaces'];
                      final List<dynamic> services = data['services'];
                      final List<dynamic> additionalImageUrls =
                          data['additionalImageUrls'];

                      return Column(
                        children: <Widget>[
                          SizedBox(height: 16.0),
                          // Title
                          Text(
                            name, // Display the name
                            style: TextStyle(
                              color: secondary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
