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
  final TextEditingController _servicesController = TextEditingController();
  final List<String> _services = [];
  File? _selectedImage;
  String? _imageUrl; // New variable to store the image URL

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
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

  Future<void> _create() async {
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
                    // Display selected image
                    if (_selectedImage != null) Image.file(_selectedImage!),
                    // Button to pick an image
                    ElevatedButton(
                      onPressed: () => _pickImage(),
                      child: const Text(
                        'Pick Image',
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
                    TextField(
                      controller: _visitedPlacesController,
                      decoration: InputDecoration(
                        labelText: 'Service in that area',
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _servicesController,
                            decoration: InputDecoration(
                              labelText: 'More Visit Places Nearly',
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final String description = _descriptionController.text;
                        final String visitedPlaces = _visitedPlacesController.text;

                        // Upload the image to Firebase Storage
                        final imageUrl = await _uploadImageToStorage(_selectedImage);

                        await _places.add({
                          "description": description,
                          "name": name,
                          "visitedplaces": visitedPlaces,
                          "services": _services,
                          "imageUrl": imageUrl, // Store the image URL in Firestore
                        });

                        _nameController.text = '';
                        _descriptionController.text = '';
                        _visitedPlacesController.text = '';
                        _servicesController.text = '';
                        _services.clear();
                        _selectedImage = null; // Clear the selected image
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                ),
              )
          ),
        );
      },
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _descriptionController.text = documentSnapshot['description'];
      _visitedPlacesController.text = documentSnapshot['visitedplaces'];
      _servicesController.text = '';
      setState(() {
        _services.clear();
        _services.addAll((documentSnapshot['services'] as List).cast<String>());
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
                        TextField(
                          controller: _visitedPlacesController,
                          decoration: InputDecoration(
                            labelText: 'Service in that area',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _servicesController,
                                decoration: InputDecoration(
                                  labelText: 'More Visit Places Nearly',
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
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: const Text('Update'),
                          onPressed: () async {
                            final String name = _nameController.text;
                            final String description = _descriptionController.text;
                            final String visitedPlaces = _visitedPlacesController.text;


                            await _places.doc(documentSnapshot?.id).update({
                              "description": description,
                              "name": name,
                              "visitedplaces": visitedPlaces,
                              "services": _services,
                            });

                            _nameController.text = '';
                            _descriptionController.text = '';
                            _visitedPlacesController.text = '';
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
                final String imageUrl = documentSnapshot['imageUrl']; // Extract imageUrl
                final String name = documentSnapshot['name']; // Extract name

                return Card(
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