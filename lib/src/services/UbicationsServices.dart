import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:segimutiplataform/src/models/Ubication.dart';

class UbicationsServices {
  static saveUbication(Ubication ubication) async {
    var url = Uri.https('segi-back.onrender.com', 'api/locations/insertOne');
    var body = jsonEncode(<String, dynamic>{
      "coordinates" : {
        "lat" : ubication.coordinates.lat,
        "lng" : ubication.coordinates.lng
      },
      "address" : ubication.address,
      "user_email" : ubication.userEmail
    });
    print(body);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    print(response.body);
  }

  static Future<List<LatLng>> getUbications(String emailReq) async {
    var url = Uri.https(
      'segi-back.onrender.com',
      'api/locations/getByUser/$emailReq',
    );
    final res = await http.get(url);
    final locations = locationFromJson(res.body);
    List<LatLng> ubications = [];
    for (int i = 0; i < locations.data.length; i++) {
      ubications.add(
        LatLng(
          latitude: locations.data[i].coordinates.lat,
          longitude: locations.data[i].coordinates.lng,
        ),
      );
    }
    return ubications;
  }
}
