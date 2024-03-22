import 'package:mobile/api/api_cliente.dart';
import 'package:mobile/model/granja_model.dart';
import 'package:mobile/repositories/granja/granja_repository.dart';

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
      print(e);
      throw Exception('Erro ao obter lista de granjas');
    }
  }
}
