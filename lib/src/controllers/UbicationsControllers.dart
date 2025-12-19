import 'dart:convert';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:segimutiplataform/src/models/Ubication.dart';
import 'package:segimutiplataform/src/services/UbicationsServices.dart';

class UbicationsControllers {
  static saveUbication(Ubication ubication) async {
    var body = jsonEncode(<String, dynamic>{
      "coordinates" : {
        "lat" : ubication.coordinates.lat,
        "lng" : ubication.coordinates.lng
      },
      "address" : ubication.address,
      "user_email" : ubication.userEmail
    });
    var res = await UbicationsServices.saveUbication(body);
    print(res.body);
  }

  static Future<List<LatLng>> getUbications(String emailReq) async {
    final res = await UbicationsServices.getUbications(emailReq);
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
