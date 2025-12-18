

import 'package:segimutiplataform/src/models/User.dart';
import 'package:segimutiplataform/src/services/UserServicies.dart';

class RegisterController {
  final UserServices _userServices = UserServices();

  Future <String> procesarRegistro({
    required String name,
    required String lastname,
    required String email,
    required String password,
    required String confirmPassword,

})async{
    if(name.isEmpty || email.isEmpty || password.isEmpty){
      return "Todos los campos son obligatorios";

    }

    if(password != confirmPassword){
      return "Las contraseñas no coinciden";
    }

    User nuevoUsuario = User(
      name: name,
      lastname: lastname,
      email: email,
      password: password,
    );

    bool esExistoso = await _userServices.registrarUsuario(nuevoUsuario);

    return esExistoso ? "SUCCESS" : "Error al conectar con el servidor";
  }


}