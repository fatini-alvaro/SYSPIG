import 'package:dio/dio.dart';
import 'package:mobile/services/prefs_service.dart';// Importe o serviço de preferências do seu aplicativo

class ApiClient {
  late Dio _dio;

  ApiClient() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://localhost:3000',
    );

    _dio = Dio(options);

     setupApiClient();
  }

  Dio get dio => _dio;

  Future<void> setupApiClient() async {
    int? userId = await PrefsService.getUserId();
    int? fazendaId = await PrefsService.getFazendaId();

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Exemplo: Adicionar token de autenticação
        // options.headers['Authorization'] = 'Bearer $token';

        if (userId != null) {
          options.headers['user-id'] = userId.toString();
        }

        if (fazendaId != null) {
          options.headers['fazenda-id'] = fazendaId.toString();
        }

        return handler.next(options);
      },
    ));
  }
}
