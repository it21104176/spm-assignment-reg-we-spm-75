// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class InterestPlace extends StatefulWidget {
//   const InterestPlace({Key? key}) : super(key: key);
//
//   @override
//   _InterestPlaceState createState() => _InterestPlaceState();
// }
//
// class _InterestPlaceState extends State<InterestPlace> {
//   // Text fields' controllers
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _interestPlaceController =
//       TextEditingController();
//
//   final CollectionReference _poiCollection = FirebaseFirestore.instance
//       .collection(
//           'PointOfInterest'); // Change to your Firestore collection name
//
//   Future<void> _create() async {
//     await showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (BuildContext ctx) {
//         return Padding(
//           padding: EdgeInsets.only(
//             top: 20,
//             left: 20,
//             right: 20,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   labelStyle:
//                       TextStyle(color: Colors.grey), // Set label color to grey
//                 ),
//               ),
//               TextField(
//                 controller: _interestPlaceController,
//                 decoration: const InputDecoration(
//                   labelText: 'Point Of Interest',
//                   labelStyle:
//                       TextStyle(color: Colors.grey), // Set label color to grey
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.grey, // Set button color to grey
//                 ),
//                 child: const Text('Create'),
//                 onPressed: () async {
//                   final String description = _descriptionController.text;
//                   final String interestPlace = _interestPlaceController.text;
//
//                   if (description.isNotEmpty && interestPlace.isNotEmpty) {
//                     await _poiCollection.add({
//                       "Description": description,
//                       "PointOfInterest": interestPlace,
//                     });
//
//                     _descriptionController.text = '';
//                     _interestPlaceController.text = '';
//                     Navigator.of(context).pop();
//                   }
//                 },
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
//     if (documentSnapshot != null) {
//       _descriptionController.text = documentSnapshot['Description'];
//       _interestPlaceController.text = documentSnapshot['PointOfInterest'];
//     }
//
//     await showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (BuildContext ctx) {
//         return Padding(
//           padding: EdgeInsets.only(
//             top: 20,
//             left: 20,
//             right: 20,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   labelStyle:
//                       TextStyle(color: Colors.grey), // Set label color to grey
//                 ),
//               ),
//               TextField(
//                 controller: _interestPlaceController,
//                 decoration: const InputDecoration(
//                   labelText: 'Point Of Interest',
//                   labelStyle:
//                       TextStyle(color: Colors.grey), // Set label color to grey
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.grey, // Set button color to grey
//                 ),
//                 child: const Text('Update'),
//                 onPressed: () async {
//                   final String description = _descriptionController.text;
//                   final String interestPlace = _interestPlaceController.text;
//
//                   if (description.isNotEmpty && interestPlace.isNotEmpty) {
//                     await _poiCollection.doc(documentSnapshot!.id).update({
//                       "Description": description,
//                       "PointOfInterest": interestPlace,
//                     });
//
//                     _descriptionController.text = '';
//                     _interestPlaceController.text = '';
//                     Navigator.of(context).pop();
//                   }
//                 },
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _delete(String poiId) async {
//     await _poiCollection.doc(poiId).delete();
//
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('You have successfully deleted a Point Of Interest')));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(200),
//         child: AppBar(
//           title: const Text("Interest"),
//           centerTitle: true,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/banner.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: _poiCollection.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             return ListView.builder(
//               itemCount: streamSnapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 final DocumentSnapshot documentSnapshot =
//                     streamSnapshot.data!.docs[index];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(documentSnapshot['Description']),
//                     subtitle: Text(documentSnapshot['PointOfInterest']),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () => _update(documentSnapshot),
//                             color: Colors.green, // Set the edit button color
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () => _delete(documentSnapshot.id),
//                             color: Colors.red, // Set the delete button color
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//       // Add new Point Of Interest
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _create(),
//         child: const Icon(Icons.add),
//         backgroundColor:
//             Colors.grey, // Set the background color of the add button
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _generatePdfReport() async {
    final pdf = pw.Document();

    // Add a title to the PDF report
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Point of Interest Report', style: pw.TextStyle(fontSize: 24)),
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
                pw.Text('Description: $description', style: pw.TextStyle(fontSize: 16)),
                pw.Text('Point Of Interest: $pointOfInterest', style: pw.TextStyle(fontSize: 16)),
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

    // Display the PDF summary using flutter_pdfview
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text('PDF Summary')),
        body: PDFView(
          filePath: pdfFile.path,
          // You can add more options and configurations here
        ),
      ),
    ));
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle:
                  TextStyle(color: Colors.grey), // Set label color to grey
                ),
              ),
              TextField(
                controller: _interestPlaceController,
                decoration: const InputDecoration(
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
              ),
              ElevatedButton(
                onPressed: () {
                  _generatePdfReport();
                },
                child: const Text('Generate PDF Report'),
              ),
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle:
                  TextStyle(color: Colors.grey), // Set label color to grey
                ),
              ),
              TextField(
                controller: _interestPlaceController,
                decoration: const InputDecoration(
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
                    await _poiCollection.doc(documentSnapshot.id).update({
                      "Description": description,
                      "PointOfInterest": interestPlace,
                    });

                    _descriptionController.text = '';
                    _interestPlaceController.text = '';
                    Navigator.of(ctx).pop(); // Close the update modal
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Updated successfully!'),
                    ));
                  }
                },
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


