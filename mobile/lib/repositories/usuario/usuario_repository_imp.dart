import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mobile/model/usuario_model.dart';
import 'package:mobile/repositories/usuario/usuario_repository.dart';

class UsuarioRepositoryImp implements UsuarioRepository {
  @override
  Future<UsuarioModel> auth(String username, String password) async {
    try {
      var data = {
        'email': username,
        'senha': password,
      };

      var response = await Dio().post(
        'http://192.168.2.201:3000/auth',
        data: data,
      );

      return UsuarioModel.fromJson(response.data);
    } catch (e) {
      Logger().e('Ocorreu um erro: $e');
      throw Exception('Erro na autenticação');
    }
  }
}
