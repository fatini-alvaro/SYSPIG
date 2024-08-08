import 'package:syspig/api/api_cliente.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/repositories/lote/lote_repository.dart';
import 'package:logger/logger.dart';

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
      Logger().e('Erro ao obter lista de lotes (lista - lotes): $e');
      throw Exception('Erro ao obter lista de lotes');
    }
  }

  @override
  Future<bool> delete(int loteId) async {
    try {
      var response = await _apiClient.dio.delete('/lotes/$loteId');
      
      if (response.statusCode == 200) {
        return true; // Exclusão bem-sucedida
      } else {
        return false; // Exclusão falhou
      }
    } catch (e) {
      Logger().e('Erro ao excluir lote (delete - lote): $e');
      throw Exception('Erro ao excluir lote');
    }
  }

  @override
  Future<LoteModel> create(LoteModel lote) async {
    try {
      Map<String, dynamic> loteData = {
        'descricao': lote.descricao,
        'numero_lote': lote.numeroLote,
        'lote_animais': lote.loteAnimais?.map((loteAnimal) => {
          'animal': {'id': loteAnimal.animal?.id}
        }).toList(),
      };

      var response = await _apiClient.dio.post('/lotes', data: loteData);
      return LoteModel.fromJson(response.data);
    } catch (e) {      
      Logger().e('Erro ao criar lote (create - lotes): $e');
      throw Exception('Erro ao criar lote');
    }
  }

  @override
  Future<LoteModel> update(LoteModel lote) async {
    try {
      Map<String, dynamic> loteData = {
        'descricao': lote.descricao,
        'numero_lote': lote.numeroLote,
        'lote_animais': lote.loteAnimais?.map((loteAnimal) => {
          'animal': {'id': loteAnimal.animal?.id}
        }).toList(),
      };

      var loteId = lote.id;

      var response = await _apiClient.dio.put('/lotes/$loteId', data: loteData);
      return LoteModel.fromJson(response.data);
    } catch (e) {    
      Logger().e('Erro ao editar lote (update - lote): $e');
      throw Exception('Erro ao editar lote');
    }
  }
}
