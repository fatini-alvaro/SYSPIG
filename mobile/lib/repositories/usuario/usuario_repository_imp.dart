import 'package:dio/dio.dart';
import 'package:syspig/api/api_client.dart';
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
      // Fazendo a requisição para a API para autenticar o usuário
      var response = await _apiClient.dio.post('/auth', data: {
        'email': username,
        'senha': password,
      });

      if (response.statusCode == 200) {
        // Criando um objeto UsuarioModel com o token recebido
        var usuario = UsuarioModel.fromJson(response.data['usuario']);
        var token = response.data['token'];

        // Agora podemos retornar o usuário com o token
        usuario.token = token;

        return usuario;
      } else {
        throw Exception('Falha ao autenticar');
      }
    } catch (e) {
      if (e is DioException) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response, 
          type: e.type,
        );
      } else {
        throw Exception('Falha ao autenticar');
      }
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
      if (e is DioException) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response, 
          type: e.type,
        );
      } else {
        throw Exception('Erro ao criar usuário');
      }
    }
  }
}
