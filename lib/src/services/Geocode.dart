import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

class Geocode {

  static Future<LatLng?> getLatLng(String destination) async {
    final String KEY = "AIzaSyBsxOV1LXtLOHmh9KmNzXEShdHTgVk7OB0";
    destination = destination.trim().replaceAll(" ", "+");
    print(destination);
    var url = Uri.https(
      'segi-back.onrender.com',
      'api/geocode/getLatlng/address=$destination&key=$KEY',
    );
    var response = await http.get(url);
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
