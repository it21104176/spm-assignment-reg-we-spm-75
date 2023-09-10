import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "",
      lat = "";
  late StreamSubscription<Position> positionStream;

  String street = "Fetching street..."; // Initialize with a loading message
  String city = "Fetching city..."; // Initialize with a loading message
  String province = "Fetching province..."; // Initialize with a loading message

  @override
  void initState() {
    checkGps();
    super.initState();
  }


  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      // GPS service is enabled, check for permissions
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          // You can show a dialog or message to inform the user and guide them to enable permissions in app settings.
        } else if (permission == LocationPermission.deniedForever) {
          print('Location permissions are permanently denied');
          // You can show a dialog or message to inform the user and guide them to enable permissions in app settings.
        } else {
          haspermission = true;
          // Permission granted, proceed to get location
          getLocation();
        }
      } else {
        haspermission = true;
        // Permission already granted, proceed to get location
        getLocation();
      }
    } else {
      print('GPS Service is not enabled, turn on GPS location');
      // You can show a dialog or message to inform the user and guide them to enable GPS.
    }

    setState(() {
      // Refresh the UI
    });
  }


  getLocation() async {
    position =
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
            " , ${placemark.administrativeArea} , ${placemark
            .subAdministrativeArea} ,${placemark.country}  ";
        // Update the address state variable
        this.street = street;
        this.city = city;
        this.province = province;
      } else {
        // No address found
        this.street = "Address not available";
        this.city = "Address not available";
        this.province = "Address not available";
      }
    });

    LocationSettings locationSettings = LocationSettings(
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
        title: Text("Get GPS Location"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(50),
        color: Colors.grey, // Set the background color to grey
        child: Column(
          children: [
            Text(
              servicestatus ? "GPS is Enabled" : "GPS is disabled.",
              style: TextStyle(
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
            Text(
              haspermission ? "GPS is Enabled" : "GPS is disabled.",
              style: TextStyle(
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
            Text(
              "Longitude: $long",
              style: TextStyle(
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
            Text(
              "Latitude: $lat",
              style: TextStyle(
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
            Text(
              "Address: $street",
              style: TextStyle(
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
            Text(
              "Address: $city",
              style: TextStyle(
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
            Text(
              "Address: $province",
              style: TextStyle(
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}