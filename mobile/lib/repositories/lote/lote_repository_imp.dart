import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/repositories/lote/lote_repository.dart';
import 'package:logger/logger.dart';
import 'package:syspig/utils/error_handler_util.dart';

class LoteRepositoryImp implements LoteRepository {   

  late final ApiClient _apiClient;

  LoteRepositoryImp() {
    _apiClient = ApiClient();
  }

  @override
  Future<List<LoteModel>> getList(int fazendaId) async {    
    try {
      var response = await _apiClient.dio.get('/lotes/$fazendaId');
      return (response.data as List).map((e) => LoteModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de lotes');
      Logger().e('Erro ao obter lista de lotes (lista - lotes): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<LoteModel>> getListAtivos(int fazendaId) async {    
    try {
      var response = await _apiClient.dio.get('/lotes/ativos/$fazendaId');
      return (response.data as List).map((e) => LoteModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de lotes ativos');
      Logger().e('Erro ao obter lista de lotes ativos (lista - lotes ativos): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<LoteModel> getById(int loteId) async {
    try {
      var response = await _apiClient.dio.get('/lotes/lote/$loteId');
      return LoteModel.fromJson(response.data);
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter dados do lote');
      Logger().e('Erro ao obter dados do lote: $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> delete(int loteId) async {
    try {
      var response = await _apiClient.dio.delete('/lotes/$loteId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        throw Exception(response.data['message'] ?? 'Erro desconhecido ao excluir anotação');
      }
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao excluir lote');
      Logger().e('Erro ao excluir lote (delete - lote): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<LoteModel> create(LoteModel lote) async {
    try {
      var response = await _apiClient.dio.post('/lotes', data: lote.toJson());
      return LoteModel.fromJson(response.data);
    } catch (e) {      
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar lote');
      Logger().e('Erro ao criar lote (create - lotes): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<LoteModel> update(LoteModel lote) async {
    try {
      var loteId = lote.id;
      var response = await _apiClient.dio.put('/lotes/$loteId', data: lote.toJson());
      return LoteModel.fromJson(response.data);
    } catch (e) {    
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar lote');
      Logger().e('Erro ao editar lote (update - lote): $e');
      throw Exception(errorMessage);
    }
  }
}
