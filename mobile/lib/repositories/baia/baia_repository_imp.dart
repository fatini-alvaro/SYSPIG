import 'package:logger/logger.dart';
import 'package:mobile/api/api_cliente.dart';
import 'package:mobile/model/baia_model.dart';
import 'package:mobile/repositories/baia/baia_repository.dart';

class BaiaRepositoryImp implements BaiaRepository {   

  late final ApiClient _apiClient;

  BaiaRepositoryImp() {
    _apiClient = ApiClient();
  }  

  Future<List<BaiaModel>> getList(int granjaId) async {
    try {
      var response = await _apiClient.dio.get('/baias/$granjaId');
      return (response.data as List).map((e) => BaiaModel.fromJson(e)).toList();
    } catch (e) {
      Logger().e('Erro ao obter lista de baias (lista - baias): $e');
      throw Exception('Erro ao obter lista de baias');
    }
  }

  @override
  Future<BaiaModel> create(BaiaModel baia) async {
    try {
      Map<String, dynamic> baiaData = {
        'granja_id': baia.granja.id,
        'numero': baia.numero,
      };

      var response = await _apiClient.dio.post('/baias', data: baiaData);
      return BaiaModel.fromJson(response.data);
    } catch (e) {      
      Logger().e('Erro ao criar baia (create - baias): $e');
      throw Exception('Erro ao criar baia');
    }
  }

  @override
  Future<BaiaModel> update(BaiaModel baia) async {
    try {
      Map<String, dynamic> baiaData = {
        'granja_id': baia.granja.id,
        'numero': baia.numero,
      };

      var baiaId = baia.id;

      var response = await _apiClient.dio.put('/baias/$baiaId', data: baiaData);
      return BaiaModel.fromJson(response.data);
    } catch (e) {    
      Logger().e('Erro ao editar baia (update - baias): $e');
      throw Exception('Erro ao editar baia');
    }
  }

  @override
  Future<bool> delete(int baiaId) async {
    try {
      var response = await _apiClient.dio.delete('/baias/$baiaId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        return false; // Exclusão falhou
      }
    } catch (e) {
      Logger().e('Erro ao excluir baia (delete - baia): $e');
      throw Exception('Erro ao excluir baia');
    }
  }
}
