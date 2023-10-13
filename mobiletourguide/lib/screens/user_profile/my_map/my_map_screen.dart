//InBuild Package Import
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Pub Package Import
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Local Import
import 'alert_dialog.dart';
import 'location_service.dart';
import 'map_location_search_widget.dart';

class MyMapScreen extends StatefulWidget {
  const MyMapScreen({super.key});

  @override
  State<MyMapScreen> createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  //Set properties
  late final Completer<GoogleMapController> _controller;
  late final TextEditingController _originController;
  late final TextEditingController _destinationController;
  late Set<Marker> _markers;
  late Set<Polyline> _polylines;

  //initial Camera position
  late final CameraPosition _initialCameraPosition;

//init
  @override
  void initState() {
    _controller = Completer<GoogleMapController>();
    _originController = TextEditingController();
    _destinationController = TextEditingController();
    _markers = <Marker>{};
    _polylines = <Polyline>{};
    _initialCameraPosition = const CameraPosition(
      target: LatLng(
        6.9270786,
        79.861243,
      ),
      zoom: 14.4746,
    );

    super.initState();
  }

  void findMyPathButtonPress() async {
    if (_originController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty) {
      try {
        //Retrieve location and direction data from the APIs.
        final directions = await getDirections();

        if (directions != null) {
          //Navigate to those locations.
          _goToMyPathLocations(
            directions['start_location']['lat'],
            directions['start_location']['lng'],
            directions['bounds_ne'],
            directions['bounds_sw'],
          );

          //Set markers at those exact locations
          _setMarker(
            LatLng(
              directions['start_location']['lat'],
              directions['start_location']['lng'],
            ),
            LatLng(
              directions['end_location']['lat'],
              directions['end_location']['lng'],
            ),
          );

          //Add a Polyline between those locations
          _setPolyline(directions['polyline_decoded']);
        }
      } catch (e) {
        if (mounted) {
          alertDialog(context: context, content: e.toString());
        }
      }
    } else {
      alertDialog(
          context: context, content: "Please Add Your Origin & Destination");
    }
  }

  //Retrieve location and direction data from the APIs.
  Future<Map<String, dynamic>?> getDirections() async {
    final locationService = LocationService();
    return await locationService.getDirections(
        _originController.text, _destinationController.text);
  }

  Future<void> _goToMyPathLocations(
      double latStart,
      double lngStart,
      Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw,
      ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latStart, lngStart),
          zoom: 12,
        ),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(
                boundsSw['lat'],
                boundsSw['lng'],
              ),
              northeast: LatLng(
                boundsNe['lat'],
                boundsNe['lng'],
              )),
          40),
    );
  }

  Future<void> _setMarker(LatLng originPoint, LatLng destinationPoint) async {
    final Uint8List originPointerIcon = await rootBundle
        .load(
      'assets/for_maps/origin_pointer.png',
    )
        .then((byteData) => byteData.buffer.asUint8List());
    final Uint8List destinationPointerIcon = await rootBundle
        .load('assets/for_maps/destination_pointer.png')
        .then((byteData) => byteData.buffer.asUint8List());
    setState(() {
      _markers.addAll([
        Marker(
          markerId: const MarkerId("originMarker"),
          position: originPoint,
          icon: BitmapDescriptor.fromBytes(originPointerIcon),
        ),
        Marker(
            markerId: const MarkerId("destinationMarker"),
            position: destinationPoint,
            icon: BitmapDescriptor.fromBytes(destinationPointerIcon,
                size: const Size(2, 2))),
      ]);
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: const PolylineId("polylineId"),
        width: 5,
        color: Colors.blue,
        points: points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(),
      ),
    );
  }

//dispose textEditingControllers
  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("My Map"),
      ),
      body: Column(
        children: [
          //Location Search UI widget
          MapLocationSearchWidget(
            originController: _originController,
            destinationController: _destinationController,
            findMyPath: findMyPathButtonPress,
          ),

          //Google Map
          googleMapWidget(),
        ],
      ),
    );
  }

//Google Map
  Widget googleMapWidget() {
    return Expanded(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
