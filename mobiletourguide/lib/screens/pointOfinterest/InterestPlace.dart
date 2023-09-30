import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterestPlace extends StatefulWidget {
  const InterestPlace({Key? key}) : super(key: key);

  @override
  _InterestPlaceState createState() => _InterestPlaceState();
}

class _InterestPlaceState extends State<InterestPlace> {
  // Text fields' controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _interestPlaceController =
      TextEditingController();

  final CollectionReference _poiCollection = FirebaseFirestore.instance
      .collection(
          'PointOfInterest'); // Change to your Firestore collection name

  Future<void> _create() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle:
                      TextStyle(color: Colors.grey), // Set label color to grey
                ),
              ),
              TextField(
                controller: _interestPlaceController,
                decoration: InputDecoration(
                  labelText: 'Point Of Interest',
                  labelStyle:
                      TextStyle(color: Colors.grey), // Set label color to grey
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // Set button color to grey
                ),
                child: const Text('Create'),
                onPressed: () async {
                  final String description = _descriptionController.text;
                  final String interestPlace = _interestPlaceController.text;

                  if (description.isNotEmpty && interestPlace.isNotEmpty) {
                    await _poiCollection.add({
                      "Description": description,
                      "PointOfInterest": interestPlace,
                    });

                    _descriptionController.text = '';
                    _interestPlaceController.text = '';
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _descriptionController.text = documentSnapshot['Description'];
      _interestPlaceController.text = documentSnapshot['PointOfInterest'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle:
                      TextStyle(color: Colors.grey), // Set label color to grey
                ),
              ),
              TextField(
                controller: _interestPlaceController,
                decoration: InputDecoration(
                  labelText: 'Point Of Interest',
                  labelStyle:
                      TextStyle(color: Colors.grey), // Set label color to grey
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // Set button color to grey
                ),
                child: const Text('Update'),
                onPressed: () async {
                  final String description = _descriptionController.text;
                  final String interestPlace = _interestPlaceController.text;

                  if (description.isNotEmpty && interestPlace.isNotEmpty) {
                    await _poiCollection.doc(documentSnapshot!.id).update({
                      "Description": description,
                      "PointOfInterest": interestPlace,
                    });

                    _descriptionController.text = '';
                    _interestPlaceController.text = '';
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _delete(String poiId) async {
    await _poiCollection.doc(poiId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Point Of Interest')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          title: const Text("Interest"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banner.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _poiCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['Description']),
                    subtitle: Text(documentSnapshot['PointOfInterest']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _update(documentSnapshot),
                            color: Colors.green, // Set the edit button color
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _delete(documentSnapshot.id),
                            color: Colors.red, // Set the delete button color
                          ),
                        ],
                      ),
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
      // Add new Point Of Interest
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
        backgroundColor:
            Colors.grey, // Set the background color of the add button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
