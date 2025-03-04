import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/repositories/granja/granja_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

class GranjaRepositoryImp implements GranjaRepository {   

  late final ApiClient _apiClient;

  GranjaRepositoryImp() {
    _apiClient = ApiClient();
  }  

  Future<List<GranjaModel>> getList(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/granjas/$fazendaId');
      return (response.data as List).map((e) => GranjaModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de granjas');
      Logger().e('Erro ao obter lista de granjas (lista - Granjas): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<GranjaModel> create(GranjaModel granja) async {
    try {
      Map<String, dynamic> granjaData = {
        'descricao': granja.descricao,
        'tipo_granja_id': granja.tipoGranja?.id
      };

      var response = await _apiClient.dio.post('/granjas', data: granjaData);
      return GranjaModel.fromJson(response.data);
    } catch (e) {      
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar granja');
      Logger().e('Erro ao criar granja (create - Granjas): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<GranjaModel> update(GranjaModel granja) async {
    try {
      Map<String, dynamic> granjaData = {
        'descricao': granja.descricao,
        'tipo_granja_id': granja.tipoGranja?.id
      };

      var granjId = granja.id;

      var response = await _apiClient.dio.put('/granjas/$granjId', data: granjaData);
      return GranjaModel.fromJson(response.data);
    } catch (e) {    
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao editar granja');
      Logger().e('Erro ao editar granja (update - Granjas): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> delete(int granjaId) async {
    try {
      var response = await _apiClient.dio.delete('/granjas/$granjaId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        return false; // Exclusão falhou
      }
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao excluir granja');
      Logger().e('Erro ao excluir granja (delete - Granjas): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<GranjaModel> getById(int granjaId) async {
    try {
      var response = await _apiClient.dio.get('/granjas/granja/$granjaId');
      return GranjaModel.fromJson(response.data);
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter dados da granja');
      Logger().e('Erro ao obter dados da granja: $e');
      throw Exception(errorMessage);
    }
  }
}
