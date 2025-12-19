import 'package:http/http.dart' as http;

class UbicationsServices {
  static Future<http.Response> saveUbication(String body) async {
    var url = Uri.https('segi-back.onrender.com', 'api/locations/insertOne');
    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
  }

  static Future<http.Response> getUbications(String emailReq) async {
    var url = Uri.https(
      'segi-back.onrender.com',
      'api/locations/getByUser/$emailReq',
    );
    return await http.get(url);
  }
}
