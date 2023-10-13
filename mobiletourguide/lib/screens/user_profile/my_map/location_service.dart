import 'dart:convert' as convert;

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class LocationService {
  //! GOOGLE CLOUD API KEY
  final String key = "AIzaSyC638yjq60BVFk3_9dXDwPIJnA0IUB6Mqc";

//Retrieve direction data from one location to another.
  Future<Map<String, dynamic>?> getDirections(
      String origin, String destination) async {
    try {
      final String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key";

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        if (json["status"] == "NOT_FOUND") {
          throw "Path is Not Found";
        } else if (json["status"] == "REQUEST_DENIED") {
          throw json["error_message"];
        } else {
          var results = {
            'bounds_ne': json['routes'][0]['bounds']['northeast'],
            'bounds_sw': json['routes'][0]['bounds']['southwest'],
            'start_location': json['routes'][0]['legs'][0]['start_location'],
            'end_location': json['routes'][0]['legs'][0]['end_location'],
            'polyline_decoded': PolylinePoints().decodePolyline(
              json['routes'][0]['overview_polyline']['points'],
            ),
          };
          return results;
        }
      } else {
        throw "Something Went Wrong. Error:${response.statusCode}";
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
