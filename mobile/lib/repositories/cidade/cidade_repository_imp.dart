import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/cidade_model.dart';
import 'package:syspig/repositories/cidade/cidade_repository.dart';

class CidadeRepositoryImp implements CidadeRepository {   

  late final ApiClient _apiClient;

  CidadeRepositoryImp() {
    _apiClient = ApiClient();
  }

  @override
  Future<List<CidadeModel>> getList() async {
    try {
      var response = await _apiClient.dio.get('/cidades');
      return (response.data as List).map((e) => CidadeModel.fromJson(e)).toList();
    } catch (e) {
      Logger().e(e);
    }

    return [];
  }
}
