import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/repositories/fazenda/fazenda_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

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
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de fazendas');
      Logger().e('Erro ao obter lista de fazendas (lista - fazendas): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<FazendaModel> create(FazendaModel fazenda) async {
    try {
      var response = await _apiClient.dio.post('/fazendas', data: fazenda.toJson());
      return FazendaModel.fromJson(response.data);
    } catch (e) {      
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar fazenda');
      Logger().e('Erro ao criar fazenda (create - fazenda): $e');
      throw Exception(errorMessage);
    }
  }
}
