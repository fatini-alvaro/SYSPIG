import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/inseminacao_model.dart';
import 'package:syspig/repositories/iseminacao/inseminacao_repository.dart';

class InseminacaoRepositoryImp implements InseminacaoRepository {   

  late final ApiClient _apiClient;

  InseminacaoRepositoryImp() {
    _apiClient = ApiClient();
  }

  @override
  Future<List<InseminacaoModel>> getList() async {
    try {
      var response = await _apiClient.dio.get('/inseminacoes');
        return (response.data as List).map((e) => InseminacaoModel.fromJson(e)).toList();
    } catch (e) {
      Logger().e(e);
    }

    return [];
  }
}
