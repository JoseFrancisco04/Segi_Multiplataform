

import 'package:segimutiplataform/src/models/User.dart';
import 'package:segimutiplataform/src/services/UserServicies.dart';
import 'package:segimutiplataform/src/utils/DataBaseSegi.dart';

class LoginController{
  final UserServices _userServices = UserServices();
  final DatabaseHelper _dbhelper = DatabaseHelper();

  Future<bool> manejadorSesion(String email, String password)async{
    if(email.isEmpty || password.isEmpty) return false;
      final response = await _userServices.login(email, password);

      if(response != null && response['data'] != null){
        var userData= response['data'];
        User user = User(
          id: userData['_id'],
          name: userData['name'],
          lastname: userData['lastname'],
          email: userData['email'],
          password: "",
        );
        await _dbhelper.saveSession(user);
        return true;
      }
      return false;

  }

  Future<bool> cerrarSesion()async{
    await _dbhelper.deleteSession();
    return true;
    
  }

}