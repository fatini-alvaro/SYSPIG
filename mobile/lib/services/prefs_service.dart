import 'dart:convert';
import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/model/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {

  static final String _key = 'key';

  static save(UsuarioModel user) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _key, 
      jsonEncode({
        "user": user.toJson(),
        "isAuth": true,
      }),
    );
  }

  static Future<UsuarioModel?> getUser() async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      try {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        var userJson = userData['user'];
        return UsuarioModel.fromJson(userJson);
      } catch (e) {
        print("Error decoding user data: $e");
        return null;
      }
    }
    return null;
  }

  static Future<int?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      var user = userData['user'];
      return user['id'];
    }
    return null; // Retorna null se não encontrar o ID do usuário
  }

  static Future<FazendaModel?> getFazenda() async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      try {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        var fazendaJson = userData['fazenda'];
        return FazendaModel.fromJson(fazendaJson);
      } catch (e) {
        print("Error decoding user data: $e");
        return null;
      }
    }
    return null;
  }

  static int? getUserIdFromUserString(String userString) {
    // Lógica para extrair o ID do usuário da string
    // Por exemplo: 'User(id: 123, name: John)' => 123
    var idStartIndex = userString.indexOf('id: ') + 4;
    var idEndIndex = userString.indexOf(',', idStartIndex);
    var userIdString = userString.substring(idStartIndex, idEndIndex);
    var userId = int.tryParse(userIdString);
    return userId;
  }

  static Future<bool> isAuth() async {
    var prefs = await SharedPreferences.getInstance();

    var jsonResult = prefs.getString(_key);
    if(jsonResult != null) {
      var mapUser = jsonDecode(jsonResult);
      return mapUser['isAuth'];
    }

    return false;
  }

  static logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static setFazenda(FazendaModel fazenda) async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      userData['fazenda'] = fazenda.toJson(); 
      prefs.setString(_key, jsonEncode(userData));
    }
  }
}