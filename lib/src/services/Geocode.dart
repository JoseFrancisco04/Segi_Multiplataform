import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Geocode {

  static Future request(String destination) async {
    final String KEY = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'Clave no encontrada';
    destination = destination.trim().replaceAll(" ", "+");
    var url = Uri.https(
      'segi-back.onrender.com',
      'api/geocode/getLatlng/address=$destination&key=$KEY',
    );
    return await http.get(url);
  }
}
