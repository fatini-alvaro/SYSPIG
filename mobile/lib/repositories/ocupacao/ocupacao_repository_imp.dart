import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/enums/ocupacao_animal_constants.dart';
import 'package:syspig/model/ocupacao_animal_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

class OcupacaoRepositoryImp implements OcupacaoRepository {   

  late final ApiClient _apiClient;

  OcupacaoRepositoryImp() {
    _apiClient = ApiClient();
  }  

  @override
  Future<OcupacaoModel> create(OcupacaoModel ocupacao) async {
    try {
      var response = await _apiClient.dio.post('/ocupacoes', data: ocupacao.toJson());
      return OcupacaoModel.fromJson(response.data);
    } catch (e) {      
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao criar ocupação');
      Logger().e('Erro ao criar ocupações (create - ocupações): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<OcupacaoModel> getById(int ocupacaoId) async {
    try {
      var response = await _apiClient.dio.get('/ocupacoes/ocupacao/$ocupacaoId');
      return OcupacaoModel.fromJson(response.data);
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter dados da ocupação');
      Logger().e('Erro ao obter dados da ocupação: $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<OcupacaoModel> getByBaiaId(int baiaId) async {
    try {
      var response = await _apiClient.dio.get('/ocupacoes/getbybaia/$baiaId');
      return OcupacaoModel.fromJson(response.data);
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter dados da ocupação');
      Logger().e('Erro ao obter dados da ocupação: $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<OcupacaoModel>> getList(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/ocupacoes/$fazendaId');
      return (response.data as List).map((e) => OcupacaoModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de ocupações');
      Logger().e('Erro ao obter lista de ocupações (lista - Ocupações): $e');
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> movimentarAnimal({
    required int animalId,
    required int baiaDestinoId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/ocupacoes/movimentar-animal',
        data: {
          'animal_id': animalId,
          'baia_destino_id': baiaDestinoId,
        },
      );
      return response.data;
    } catch (e) {
      Logger().e('Erro ao movimentar animal: $e');
      rethrow;
    }
  }
}
