import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobiletourguide/screens/PlacesListPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DisplayPlaces());
}


class DisplayPlaces extends StatefulWidget {
  const DisplayPlaces({Key? key}) : super(key: key);

  @override
  _DisplayPlacesState createState() => _DisplayPlacesState();
}

class _DisplayPlacesState extends State<DisplayPlaces> {

  final CollectionReference _places = FirebaseFirestore.instance.collection('places');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Favourite Places')),
      ),
      body: StreamBuilder(
        stream: _places.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                final String imageUrl = documentSnapshot['imageUrl']; // Extract imageUrl
                final String name = documentSnapshot['name']; // Extract name
                final String placeId = documentSnapshot.id; // Get the document ID

                return GestureDetector(
                    onTap: () {
                  // Navigate to the details page when a card is tapped.
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
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 22,
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
