
import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/venda_model.dart';
import 'package:syspig/repositories/venda/venda_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

class VendaRepositoryImp implements VendaRepository {   

  late final ApiClient _apiClient;

  VendaRepositoryImp() {
    _apiClient = ApiClient();
  }  
  
  @override
  Future<List<VendaModel>> getList(int fazendaId) async {
    try {
      var response = await _apiClient.dio.get('/vendas/$fazendaId');
      return (response.data as List).map((e) => VendaModel.fromJson(e)).toList();
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter lista de vendas');
      Logger().e('Erro ao obter lista de vendas (lista - vendas): $e');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> createVenda({
    required DateTime data_venda,
    required int quantidadeVendida,
    required double valorVenda,
    required double peso,
    required List<Map<String, int>> animais
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/vendas',
        data: {
          'data_venda': data_venda.toIso8601String(),
          'quantidade': quantidadeVendida,
          'valor_venda': valorVenda,
          'peso': peso,
          'animais': animais,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao adicionar vendas');
      Logger().e('Erro ao adicionar vendas: $e');
      throw Exception(errorMessage);
    }
  }

}
