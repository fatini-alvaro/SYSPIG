import 'package:mobile/api/api_cliente.dart';
import 'package:mobile/model/cidade_model.dart';
import 'package:mobile/repositories/cidade/cidade_repository.dart';

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
      print(e);
    }

    return [];
  }
}
