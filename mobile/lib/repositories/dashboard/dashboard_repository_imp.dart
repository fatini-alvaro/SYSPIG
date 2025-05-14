import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:syspig/api/api_client.dart';
import 'package:syspig/model/dashboard_model.dart';
import 'package:syspig/repositories/dashboard/dashboard_repository.dart';
import 'package:syspig/utils/error_handler_util.dart';

class DashboardRepositoryImp implements DashboardRepository {   

  late final ApiClient _apiClient;

  DashboardRepositoryImp() {
    _apiClient = ApiClient();
  }  

  @override
  Future<DashboardModel> getDados(int fazendaId) async {
    try {
      final DateTime today = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(today);

      var response = await _apiClient.dio.get(
        '/dashboard/$fazendaId',
        queryParameters: {
          'startDate': formattedDate,
          'endDate': formattedDate,
        },
      );

      return DashboardModel.fromJson(response.data);
    } catch (e) {
      String errorMessage = ErrorHandlerUtil.handleDioError(e, 'Erro ao obter dados do dashboard');
      Logger().e('Erro ao obter dados do dashboard: $e');
      throw Exception(errorMessage);
    }
  }
}