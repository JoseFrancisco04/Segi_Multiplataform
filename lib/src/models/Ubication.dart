// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

Ubications locationFromJson(String str) => Ubications.fromJson(json.decode(str));

String locationToJson(Ubications data) => json.encode(data.toJson());

class Ubications {
  List<Ubication> data;

  Ubications({
    required this.data,
  });

  factory Ubications.fromJson(Map<String, dynamic> json) => Ubications(
    data: List<Ubication>.from(json["data"].map((x) => Ubication.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Ubication {
  Coordinates coordinates;
  String address;
  String userEmail;

  Ubication({
    required this.coordinates,
    required this.address,
    required this.userEmail,
  });

  factory Ubication.fromJson(Map<String, dynamic> json) => Ubication(
    coordinates: Coordinates.fromJson(json["coordinates"]),
    address: json["address"],
    userEmail: json["user_email"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "coordinates": coordinates.toJson(),
    "user_email": userEmail
  };
}

class Coordinates {
  double lat;
  double lng;

  Coordinates({
    required this.lat,
    required this.lng,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}


/*

class Location{
  String _email;
  String _placeName;
  double _lat;
  double _lng;
  Location(this._email, this._placeName, this._lat, this._lng);

  double get lng => _lng;

  double get lat => _lat;

  String get email => _email;

  String get placeName => _placeName;
}
 */
