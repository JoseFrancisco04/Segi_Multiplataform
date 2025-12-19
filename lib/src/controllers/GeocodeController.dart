import 'dart:convert';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:segimutiplataform/src/services/Geocode.dart';

class GeocodeController {

  static Future<LatLng?> getLatLng(String destination) async {
    var response = await Geocode.request(destination);
    final body = jsonDecode(response.body);

    if (body['status'] != "OK") {
      return null;
    }

    return LatLng(
      latitude: body['latlng']['lat'],
      longitude: body['latlng']['lng'],
    );
  }
}
