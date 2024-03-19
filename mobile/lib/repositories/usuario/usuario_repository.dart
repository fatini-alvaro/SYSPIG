import 'package:mobile/model/usuario_model.dart';

abstract class UsuarioRepository {

  Future<UsuarioModel> auth(String username, String password);

}