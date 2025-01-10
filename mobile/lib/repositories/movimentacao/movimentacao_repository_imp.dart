import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/movimentacao_model.dart';
import 'package:syspig/repositories/movimentacao/movimentacao_repository.dart';

class MovimentacaoRepositoryImp implements MovimentacaoRepository {

  late final ApiClient _apiClient;

  MovimentacaoRepositoryImp() {
    _apiClient = ApiClient();
  } 

  @override
  Future<List<MovimentacaoModel>> getList() async {
    try {
      var response = await _apiClient.dio.get('/movimentacoes');
      return (response.data as List).map((e) => MovimentacaoModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}