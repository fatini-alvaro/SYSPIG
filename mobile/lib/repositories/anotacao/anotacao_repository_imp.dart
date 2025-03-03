import 'package:dio/dio.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/repositories/anotacao/anotacao_repository.dart';
import 'package:logger/logger.dart';
import 'package:syspig/utils/error_handler_util.dart';

class AnotacaoRepositoryImp implements AnotacaoRepository {   

  late final ApiClient _apiClient;

  AnotacaoRepositoryImp() {
    _apiClient = ApiClient();
  }  

  @override
  Future<List<AnotacaoModel>> getList(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/anotacoes/$fazendaId');
      return (response.data as List).map((e) => AnotacaoModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de anotacoes');
      Logger().e('Erro ao obter lista de anotacoes (lista - anotacoes): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<AnotacaoModel> getById(int anotacaoId) async {
    try {
      var response = await _apiClient.dio.get('/anotacoes/anotacao/$anotacaoId');
      return AnotacaoModel.fromJson(response.data);
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter dados da anotação');
      Logger().e('Erro ao obter dados da anotação: $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<AnotacaoModel> create(AnotacaoModel anotacao) async {
    try {
      var response = await _apiClient.dio.post('/anotacoes', data: anotacao.toJson());
      return AnotacaoModel.fromJson(response.data);
    } catch (e) {      
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar anotação');
      Logger().e('Erro ao criar anotacao (create - anotacoes): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<AnotacaoModel> update(AnotacaoModel anotacao) async {
    try {
      var anotacaoId = anotacao.id;
      var response = await _apiClient.dio.put('/anotacoes/$anotacaoId', data: anotacao.toJson());
      return AnotacaoModel.fromJson(response.data);
    } catch (e) {    
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao editar anotação');
      Logger().e('Erro ao editar anotação (update - anotação): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> delete(int anotacaoId) async {
    try {
      var response = await _apiClient.dio.delete('/anotacoes/$anotacaoId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        throw Exception(response.data['message'] ?? 'Erro desconhecido ao excluir anotação');
      }
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao excluir anotação');
      Logger().e('Erro ao excluir anotação (delete - anotação): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<AnotacaoModel>> getAnotacoesByBaia(int baiaId) async {
    try {
      var response = await _apiClient.dio.get('/anotacoes/getbybaia/$baiaId');
      return (response.data as List).map((e) => AnotacaoModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao recuperar anotações');
      Logger().e('Erro ao recuperar anotações (getAnotacoesByBaia - anotação): $e');
      throw Exception(errorMessage);
    }
  }
}
