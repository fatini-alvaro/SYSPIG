import 'package:dio/dio.dart';

class ErrorHandlerUtil {
  static String handleDioError(dynamic error, String defaultMessage) {
    if (error is DioException) {
      if (error.response != null && error.response!.data != null) {
        return error.response!.data['message'] ?? defaultMessage;
      } else {
        return 'Erro ao conectar com o servidor';
      }
    }
    return defaultMessage;
  }
}
