import 'package:mobile/api/api_cliente.dart';
import 'package:mobile/model/granja_model.dart';
import 'package:mobile/repositories/granja/granja_repository.dart';

class GranjaRepositoryImp implements GranjaRepository {   

  late final ApiClient _apiClient;

  GranjaRepositoryImp() {
    _apiClient = ApiClient();
  }  

  Future<List<GranjaModel>> getList(int granjaId) async {
    try {
      var response = await _apiClient.dio.get('/granjas/$granjaId');
      return (response.data as List).map((e) => GranjaModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
      throw Exception('Erro ao obter lista de granjas');
    }
  }

  @override
  Future<GranjaModel> create(GranjaModel granja) async {
    try {
      Map<String, dynamic> granjaData = {
        'descricao': granja.descricao,
        'tipo_granja_id': granja.tipoGranja.id
      };

      var response = await _apiClient.dio.post('/granjas', data: granjaData);
      return GranjaModel.fromJson(response.data);
    } catch (e) {      
      print(e);
      throw Exception('Erro ao criar granja');
    }
  }
}
