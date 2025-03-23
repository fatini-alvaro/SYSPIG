import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/repositories/baia/baia_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

class BaiaRepositoryImp implements BaiaRepository {   

  late final ApiClient _apiClient;

  BaiaRepositoryImp() {
    _apiClient = ApiClient();
  }  

  @override
  Future<List<BaiaModel>> getList(int granjaId) async {
    try {
      var response = await _apiClient.dio.get('/baias/$granjaId');
      return (response.data as List).map((e) => BaiaModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de baias');
      Logger().e('Erro ao obter lista de baias (lista - baias): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<BaiaModel>> getListAll(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/baias/byFazenda/$fazendaId');
      return (response.data as List).map((e) => BaiaModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de baias');
      Logger().e('Erro ao obter lista de baias (listaall - baias): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<BaiaModel> getById(int baiaId) async {
    try {
      var response = await _apiClient.dio.get('/baias/baia/$baiaId');
      return BaiaModel.fromJson(response.data);
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter dados da baia');
      Logger().e('Erro ao obter dados da baia: $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<BaiaModel> create(BaiaModel baia) async {
    try {
      var response = await _apiClient.dio.post('/baias', data: baia.toJson());
      return BaiaModel.fromJson(response.data);
    } catch (e) {      
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar baia');
      Logger().e('Erro ao criar baia (create - baia): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<BaiaModel> update(BaiaModel baia) async {
    try {
      var baiaId = baia.id;
      var response = await _apiClient.dio.put('/baias/$baiaId', data: baia.toJson());
      return BaiaModel.fromJson(response.data);
    } catch (e) {    
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao editar baia');
      Logger().e('Erro ao editar baia (update - baia): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> delete(int baiaId) async {
    try {
      var response = await _apiClient.dio.delete('/baias/$baiaId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        throw Exception(response.data['message'] ?? 'Erro desconhecido ao excluir baia');
      }
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao excluir baia');
      Logger().e('Erro ao excluir baia (delete - baia): $e');
      throw Exception(errorMessage);
    }
  }
}
