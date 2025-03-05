import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/repositories/fazenda/fazenda_repository.dart';

class FazendaRepositoryImp implements FazendaRepository {
  late final ApiClient _apiClient;

  FazendaRepositoryImp() {
    _apiClient = ApiClient();
  }

  @override
  Future<List<FazendaModel>> getList(int userId) async {
    try {
      var response = await _apiClient.dio.get('/usuariofazendas/$userId');
      return (response.data as List).map((e) => FazendaModel.fromJson(e)).toList();
    } catch (e) {
      Logger().e(e);
      throw Exception('Erro ao obter lista de fazendas');
    }
  }

  @override
  Future<FazendaModel> create(FazendaModel fazenda) async {
    try {
      Map<String, dynamic> fazendaData = {
        'nome': fazenda.nome,
        'cidade_id': fazenda.cidade?.id
      };

      var response = await _apiClient.dio.post('/fazendas', data: fazendaData);
      return FazendaModel.fromJson(response.data);
    } catch (e) {
      Logger().e('Erro ao criar fazenda (create - fazenda): $e');
      throw Exception('Erro ao criar fazenda');
    }
  }
}
