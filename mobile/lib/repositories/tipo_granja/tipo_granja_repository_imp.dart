import 'package:syspig/api/api_cliente.dart';
import 'package:syspig/model/tipo_granja_model.dart';
import 'package:syspig/repositories/tipo_granja/tipo_granja_repository.dart';

class TipoGranjaRepositoryImp implements TipoGranjaRepository {  
  late final ApiClient _apiClient;

  TipoGranjaRepositoryImp() {
    _apiClient = ApiClient();
  }

  @override
  Future<List<TipoGranjaModel>> getList() async {
    try {
      var response = await _apiClient.dio.get('/tipogranjas');
      return (response.data as List).map((e) => TipoGranjaModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
