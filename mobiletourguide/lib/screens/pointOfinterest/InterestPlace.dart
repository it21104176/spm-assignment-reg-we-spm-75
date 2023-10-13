import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../UserLocation/userLocation.dart';
import 'dart:ui';

class InterestPlace extends StatefulWidget {
  const InterestPlace({Key? key}) : super(key: key);

  @override
  _InterestPlaceState createState() => _InterestPlaceState();
}

class _InterestPlaceState extends State<InterestPlace> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _interestPlaceController = TextEditingController();
  final CollectionReference _poiCollection =

  FirebaseFirestore.instance.collection('PointOfInterest');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          title: const Text("Interest"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _update(documentSnapshot),
                          color: Colors.green,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _delete(documentSnapshot.id),
                          color: Colors.red,
                        ),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust the alignment as needed
        children: [
          FloatingActionButton(
            onPressed: () {
              _generatePdfReport();
            },
            child: const Icon(Icons.picture_as_pdf), // Change the icon to a PDF icon
          ),
          FloatingActionButton(
            onPressed: () {
              _create();
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocationPage()),
              );
            },
            child: const Icon(Icons.location_on), // Use a location icon
          ),
        ],
      ),

    );
  }
  Future<void> _generatePdfReport() async {
    final pdf = pw.Document();
    // final image = pw.MemoryImage(
       // File('assets/images/tourguidelogo.png').readAsBytesSync(),
    // // );

    // Add a title to the PDF report

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // pw.Image(image, width: 150, height: 150), // Adjust width and height as needed
              // pw.SizedBox(height: 20),
              pw.Text(
                'Point of Interest Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              // pw.Image(image, width: 150, height: 150), // Adjust width and height as needed
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );
    // Fetch data from Firestore and add it to the PDF
    final querySnapshot = await _poiCollection.get();
    for (final doc in querySnapshot.docs) {
      final description = doc['Description'];
      final pointOfInterest = doc['PointOfInterest'];

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Description: $description', style: const pw.TextStyle(fontSize: 16)),
                pw.Text('Point Of Interest: $pointOfInterest', style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
              ],
            );
          },
        ),
      );
    }

    // Save the PDF to a file
    final output = await getTemporaryDirectory();
    final pdfFile = File('${output.path}/poi_report.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Share the PDF file via WhatsApp
    await Share.shareFiles([pdfFile.path], text: 'Sharing a PDF file through WhatsApp');

    // Open the PDF file with the user's default PDF viewer
    OpenFile.open(pdfFile.path);
  }



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
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _interestPlaceController,
                decoration: InputDecoration(
                  labelText: 'Point Of Interest',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 150, // Adjust the width as needed
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF8D72DE), // Set button color to grey
                    ),
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
                    child: const Text('Create' ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                  ),
                ),
              )

            ],
          ),
        );
      },
    );
  }

  void _update(DocumentSnapshot documentSnapshot) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        _descriptionController.text = documentSnapshot['Description'];
        _interestPlaceController.text = documentSnapshot['PointOfInterest'];

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
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _interestPlaceController,
                decoration: InputDecoration(
                  labelText: 'Point Of Interest',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 150, // Adjust the width as needed
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent, // Set button color to grey
                    ),
                    onPressed: () async {
                      final String description = _descriptionController.text;
                      final String interestPlace = _interestPlaceController.text;

                      if (description.isNotEmpty && interestPlace.isNotEmpty) {
                        await _poiCollection.doc(documentSnapshot.id).update({
                          "Description": description,
                          "PointOfInterest": interestPlace,
                        });

                        _descriptionController.text = '';
                        _interestPlaceController.text = '';
                        Navigator.of(context).pop(); // Close the update modal
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Updated successfully!'),
                        ));
                      }
                    },
                    child: const Text('Update',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                  ),
                ),
              )

            ],
          ),
        );
      },
    );
  }

  void _delete(String poiId) async {
    // Show a confirmation dialog before deleting
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Not confirmed
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );


    if (confirmed != null && confirmed) {
      await _poiCollection.doc(poiId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Deleted successfully!'),
      ));
    }
  }

}


