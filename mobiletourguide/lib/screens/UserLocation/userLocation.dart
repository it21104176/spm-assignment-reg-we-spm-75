import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  String street = "Fetching street..."; // Initialize with a loading message
  String city = "Fetching city..."; // Initialize with a loading message
  String province = "Fetching province..."; // Initialize with a loading message

  bool isLoaded = false; // A flag to track if the Lottie animation has loaded

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print('Location permissions are permanently denied');
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          // Refresh the UI
        });

        getLocation();
      }
    } else {
      print('GPS Service is not enabled, turn on GPS location');
    }

    setState(() {
      // Refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Fetch the address using reverse geocoding
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      long = position.longitude.toString();
      lat = position.latitude.toString();

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        // Construct the address string from the placemark information
        String street = "${placemark.street},";
        String city = "   ${placemark.subLocality},${placemark.locality}";
        String province =
            " , ${placemark.administrativeArea} , ${placemark.subAdministrativeArea} ,${placemark.country}  ";
        // Update the address state variable
        this.street = street;
        this.city = city;
        this.province = province;
      } else {
        // No address found
        this.street = "Address not available";
        ;
        this.city = "Address not available";
        ;
        this.province = "Address not available";
        ;
      }
    });

    // Simulate a 10-second delay before showing other cards
    await Future.delayed(Duration(seconds: 10));

    // Set the flag to indicate that the Lottie animation has loaded
    setState(() {
      isLoaded = true;
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      // Similar to above, fetch and update the address when a new position is received
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get GPS Location"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Lottie.asset(
              'assets/images/GPS.json',
              // Replace with the path to your Lottie animation
              width: 250,
              height: 250,
              repeat: true,
            ),
            const SizedBox(height: 50),
            if (isLoaded)

              Container(
                decoration: BoxDecoration(
                  color:Colors.deepPurple, // Set your desired background color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Card(
                  color: const Color(0xFF8D72DE),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(servicestatus ? "GPS is Enabled" : "GPS is disabled",style: const TextStyle( fontWeight: FontWeight.bold,color: Colors.white)),
                        Text(haspermission ? "GPS is Enabled" : "GPS is disabled",style: const TextStyle( fontWeight: FontWeight.bold,color: Colors.white)),
                        const Divider(thickness: 2,color: Colors.black54,),
                        Text("Longitude: $long", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                        Text("Latitude: $lat", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                        const SizedBox(height: 16), // Add some spacing
                        Text("Address: $street", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                        Text("City: $city", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                        Text("Province: $province", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              )


          ],
        ),
      ),
    );
  }
}
