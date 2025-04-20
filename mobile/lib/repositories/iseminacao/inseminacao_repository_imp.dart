import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/inseminacao_model.dart';
import 'package:syspig/repositories/iseminacao/inseminacao_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

class InseminacaoRepositoryImp implements InseminacaoRepository {   

  late final ApiClient _apiClient;

  InseminacaoRepositoryImp() {
    _apiClient = ApiClient();
  }

  @override
  Future<Map<String, dynamic>> inseminarAnimais({
    required List<InseminacaoModel> inseminacoes,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/inseminacao',
        data: {
          'inseminacoes': inseminacoes,
        },
      );
      return response.data;
    } catch (e) {
      Logger().e('Erro ao inseminar animais: $e');
      rethrow;
    }
  }

  @override
  Future<List<InseminacaoModel>> getList(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/inseminacao/$fazendaId');
      return (response.data as List).map((e) => InseminacaoModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de inseminações');
      Logger().e('Erro ao obter lista de inseminações (lista - Inseminações): $e');
      throw Exception(errorMessage);
    }
  }
}
