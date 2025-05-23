import 'package:syspig/model/usuario_model.dart';

abstract class UsuarioRepository {

  Future<UsuarioModel> auth(String username, String password);

  Future<UsuarioModel> create(UsuarioModel usuario);

}