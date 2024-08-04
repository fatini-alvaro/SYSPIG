import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:syspig/api/api_cliente.dart';
import 'package:syspig/model/usuario_model.dart';
import 'package:syspig/repositories/usuario/usuario_repository.dart';

class UsuarioRepositoryImp implements UsuarioRepository {

  late final ApiClient _apiClient;

  UsuarioRepositoryImp() {
    _apiClient = ApiClient();
  }

  @override
  Future<UsuarioModel> auth(String username, String password) async {
    try {
      var data = {
        'email': username,
        'senha': password,
      };

      var response = await Dio().post(
        'http://localhost:3000/auth',
        data: data,
      );

      return UsuarioModel.fromJson(response.data);
    } catch (e) {
      Logger().e('Ocorreu um erro: $e');
      throw Exception('Erro na autenticação');
    }
  }

  @override
  Future<UsuarioModel> create(UsuarioModel usuario) async {
    try {
      Map<String, dynamic> usuarioData = {
        'nome': usuario.nome,
        'email': usuario.email,
        'senha': usuario.senha
      };

      var response = await _apiClient.dio.post('/usuarios', data: usuarioData);
      return UsuarioModel.fromJson(response.data);
    } catch (e) {
      
      print(e);
      throw Exception('Erro ao criar usuario');
    }
  }
}
