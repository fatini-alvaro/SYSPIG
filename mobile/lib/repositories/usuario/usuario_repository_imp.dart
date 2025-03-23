import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/usuario_model.dart';
import 'package:syspig/repositories/usuario/usuario_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

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
        var accessToken = response.data['accessToken'];

        // Agora podemos retornar o usuário com o token
        usuario.accessToken = accessToken;

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
      var response = await _apiClient.dio.post('/usuarios', data: usuario.toJson());
      return UsuarioModel.fromJson(response.data);
    } catch (e) {      
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar usuário');
      Logger().e('Erro ao criar usuário (create - Usuário): $e');
      throw Exception(errorMessage);
    }
  }
}
