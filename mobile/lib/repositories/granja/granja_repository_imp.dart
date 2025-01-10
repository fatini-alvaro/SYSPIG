import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/repositories/granja/granja_repository.dart';

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
      Logger().e('Erro ao obter lista de granjas (lista - Granjas): $e');
      throw Exception('Erro ao obter lista de granjas');
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
      Logger().e('Erro ao criar granja (create - Granjas): $e');
      throw Exception('Erro ao criar granja');
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
      Logger().e('Erro ao editar granja (update - Granjas): $e');
      throw Exception('Erro ao editar granja');
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
      Logger().e('Erro ao excluir granja (delete - Granjas): $e');
      throw Exception('Erro ao excluir granja');
    }
  }
}
