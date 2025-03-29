import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/movimentacao_model.dart';
import 'package:syspig/repositories/movimentacao/movimentacao_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

class MovimentacaoRepositoryImp implements MovimentacaoRepository {   

  late final ApiClient _apiClient;

  MovimentacaoRepositoryImp() {
    _apiClient = ApiClient();
  }  

  @override
  Future<List<MovimentacaoModel>> getList(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/movimentacoes/$fazendaId');
      return (response.data as List).map((e) => MovimentacaoModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de ocupações');
      Logger().e('Erro ao obter lista de ocupações (lista - Ocupações): $e');
      throw Exception(errorMessage);
    }
  }
}
