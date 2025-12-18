

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:segimutiplataform/src/models/User.dart';

class UserServices{

  final String _baseUrl = "https://segi-back.onrender.com/api/users";

  Future <bool> registrarUsuario(User user) async{
    try{
      final url = Uri.parse('$_baseUrl/insertOne');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }else{
        print("Error en el servidor: ${response.body}");
        return false;
      }
    }catch (e){
      print("Error en la petición: $e");
      return false;
    }
  }

  Future <Map <String, dynamic>?> login(String email, String password) async{
    try{
      final url = Uri.parse('$_baseUrl/login');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if(response.statusCode == 200){
        return jsonDecode(response.body);

      }else{

        print("Error en el login: ${response.body}");
        return null;
      }

    }catch (e){
      print("Error de conexion: $e");
      return null;

    }

  }
}