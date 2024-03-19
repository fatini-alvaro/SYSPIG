import 'dart:convert';
import 'package:mobile/model/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {

  static final String _key = 'key';

  static save(UsuarioModel user) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _key, 
      jsonEncode({
        "user": user.toString(), // Convertendo o objeto UsuarioModel para JSON e depois para string
        "isAuth": true,
      }),
    );
  }

  static Future<int?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString(_key);
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      var user = userData['user'];
      if (user is String) {
        // Extrair o ID do usuário da string
        var userId = getUserIdFromUserString(user);
        return userId;
      }
    }
    return null; // Retorna null se não encontrar o ID do usuário
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
}