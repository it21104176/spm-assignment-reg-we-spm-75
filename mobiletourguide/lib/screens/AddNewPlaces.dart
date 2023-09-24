import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AddNewPlaces());
}

class AddNewPlaces extends StatefulWidget {
  const AddNewPlaces({Key? key}) : super(key: key);

  @override
  _AddNewPlaceState createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlaces> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _visitedPlacesController = TextEditingController();
  final List<String> _visitedPlaces = [];
  final TextEditingController _servicesController = TextEditingController();
  final List<String> _services = [];
  File? _mainImage;
  List<File> _additionalImages = [];
  // String? _mainImageUrl; // New variable to store the main image URL
  // List<String> _additionalImageUrls = []; // List to store additional image URLs

  Future<void> _pickMImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _mainImage = File(pickedFile.path);
      });
    } else {
      // User canceled the image selection
    }
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _additionalImages.add(File(pickedFile.path));
      });
    } else {
      // User canceled the image selection
    }
  }
  final CollectionReference _places = FirebaseFirestore.instance.collection('places');

  Future<String?> _uploadImageToStorage(File? imageFile) async {
    try {
      if (imageFile == null) return null;

      final Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => null);
      final String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<List<String>> _uploadAdditionalImagesToStorage(List<File> imageFiles) async {
    final List<String> imageUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final File imageFile = imageFiles[i];
      try {
        final Reference storageReference =
        FirebaseStorage.instance.ref().child('add_images/${DateTime.now()}_$i.jpg');
        final UploadTask uploadTask = storageReference.putFile(imageFile);
        await uploadTask.whenComplete(() => null);
        final String imageUrl = await storageReference.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        print('Error uploading additional image $i: $e');
      }
    }

    return imageUrls;
  }

  Future<void> _create() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Scaffold(
          body: Form(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 60.0),
                    // Display main image
                    if (_mainImage != null) Image.file(_mainImage!),
                    // Button to pick main image
                    ElevatedButton(
                      onPressed: () => _pickMImage(),
                      child: const Text(
                        'Pick Main Image',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Location Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Location name.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _visitedPlacesController,
                            decoration: InputDecoration(
                              labelText: 'Places to visit : ',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: _addPlaces,
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: _visitedPlaces.map((visitedplace) {
                        return Chip(
                          label: Text(visitedplace),
                          onDeleted: () {
                            setState(() {
                              _visitedPlaces.remove(visitedplace);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _servicesController,
                            decoration: InputDecoration(
                              labelText: 'More Services ',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: _addService,
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: _services.map((service) {
                        return Chip(
                          label: Text(service),
                          onDeleted: () {
                            setState(() {
                              _services.remove(service);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () => _pickImage(),
                      child: const Text(
                        'Add Additional Images',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // Display additional images
                    Column(
                      children: _additionalImages.map((image) {
                        return Image.file(
                          image,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String description = _descriptionController.text;

                        // Upload the main image to Firebase Storage
                        final mainImageUrl = await _uploadImageToStorage(_mainImage);

                        // Upload the additional images to Firebase Storage
                        final additionalImageUrls = await _uploadAdditionalImagesToStorage(_additionalImages);

                        await _places.add({
                          "description": description,
                          "name": name,
                          "visitedplaces": _visitedPlaces,
                          "services": _services,
                          "mainImageUrl": mainImageUrl, // Store the main image URL in Firestore
                          "additionalImageUrls": additionalImageUrls, // Store the additional image URLs in Firestore
                        });

                        _nameController.text = '';
                        _descriptionController.text = '';
                        _visitedPlacesController.text = '';
                        _visitedPlaces.clear();
                        _servicesController.text = '';
                        _services.clear();
                        _mainImage = null; // Clear the main image
                        _additionalImages.clear(); // Clear the additional images
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _descriptionController.text = documentSnapshot['description'];
      _visitedPlacesController.text = '';
      _servicesController.text = '';
      setState(() {
        _services.clear();
        _services.addAll((documentSnapshot['services'] as List).cast<String>());
        _visitedPlaces.clear();
        _visitedPlaces.addAll((documentSnapshot['visitedplaces'] as List).cast<String>());
      });
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Scaffold(
          body: Form(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child:  SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 60.0),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Location Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Location name.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description : ',
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _visitedPlacesController,
                            decoration: InputDecoration(
                              labelText: 'Places top visit : ',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: _addPlaces,
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: _visitedPlaces.map((visitedplace) {
                        return Chip(
                          label: Text(visitedplace),
                          onDeleted: () {
                            setState(() {
                              _visitedPlaces.remove(visitedplace);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _servicesController,
                            decoration: InputDecoration(
                              labelText: 'More Service ',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: _addService,
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: _services.map((service) {
                        return Chip(
                          label: Text(service),
                          onDeleted: () {
                            setState(() {
                              _services.remove(service);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String description = _descriptionController.text;


                        await _places.doc(documentSnapshot?.id).update({
                          "description": description,
                          "name": name,
                          "visitedplaces": _visitedPlaces,
                          "services": _services,
                        });

                        _nameController.text = '';
                        _descriptionController.text = '';
                        _visitedPlacesController.text = '';
                        _visitedPlaces.clear();
                        _servicesController.text = '';
                        _services.clear();
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  Future<void> _delete(String placeId) async {
    await _places.doc(placeId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('You have successfully deleted a place'),
    ));
  }

  void _addService() {
    final service = _servicesController.text.trim();
    if (service.isNotEmpty) {
      setState(() {
        _services.add(service);
        _servicesController.clear(); // Clear the input field
      });
    }
  }
  void _addPlaces() {
    final visitedplace = _visitedPlacesController.text.trim();
    if (visitedplace.isNotEmpty) {
      setState(() {
        _visitedPlaces.add(visitedplace);
        _visitedPlacesController.clear(); // Clear the input field
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add New Places')),
      ),
      body: StreamBuilder(
        stream: _places.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                final String imageUrl = documentSnapshot['mainImageUrl']; // Extract imageUrl
                final String name = documentSnapshot['name']; // Extract name
                final String placeId = documentSnapshot.id;

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
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _update(documentSnapshot),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _delete(documentSnapshot.id),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            final String imageUrl = data['mainImageUrl'];
            final String name = data['name'];
            final String description = data['description'];
            final List<dynamic> visitedPlaces = data['visitedplaces'];
            final List<dynamic> services = data['services'];
            final List<dynamic> additionalImageUrls = data['additionalImageUrls'];

            return Column( // Wrap the Column in Center
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, // Center-align the content
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
                        Padding(padding: const EdgeInsets.all(12.0),
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
                        Padding(padding: const EdgeInsets.all(12.0),
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
