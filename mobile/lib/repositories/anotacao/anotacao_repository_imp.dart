import 'package:mobile/api/api_cliente.dart';
import 'package:mobile/model/anotacao_model.dart';
import 'package:mobile/repositories/anotacao/anotacao_repository.dart';
import 'package:logger/logger.dart';

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
      Logger().e('Erro ao obter lista de anotacoes (lista - anotacoes): $e');
      throw Exception('Erro ao obter lista de anotacoes');
    }
  }

  @override
  Future<AnotacaoModel> create(AnotacaoModel anotacao) async {
    try {
      Map<String, dynamic> anotacaoData = {
        'descricao': anotacao.descricao,
        'animal_id': anotacao.animal?.id,
        'baia_id': anotacao.baia?.id,
      };

      var response = await _apiClient.dio.post('/anotacoes', data: anotacaoData);
      return AnotacaoModel.fromJson(response.data);
    } catch (e) {      
      Logger().e('Erro ao criar anotacao (create - anotacoes): $e');
      throw Exception('Erro ao criar anotacao');
    }
  }

  @override
  Future<AnotacaoModel> update(AnotacaoModel anotacao) async {
    try {
      Map<String, dynamic> anotacaoData = {
        'descricao': anotacao.descricao,
        'animal_id': anotacao.animal?.id,
        'baia_id': anotacao.baia?.id,
      };

      var anotacaoId = anotacao.id;

      var response = await _apiClient.dio.put('/anotacoes/$anotacaoId', data: anotacaoData);
      return AnotacaoModel.fromJson(response.data);
    } catch (e) {    
      Logger().e('Erro ao editar anotação (update - anotação): $e');
      throw Exception('Erro ao editar anotação');
    }
  }

  @override
  Future<bool> delete(int anotacaoId) async {
    try {
      var response = await _apiClient.dio.delete('/baias/$anotacaoId');
      
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

  @override
  Future<List<AnotacaoModel>> getAnotacoesByBaia(int baiaId) async {
    try {
      var response = await _apiClient.dio.get('/anotacoes/getbybaia/$baiaId');  
      return (response.data as List).map((e) => AnotacaoModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
