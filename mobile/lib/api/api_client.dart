import 'package:dio/dio.dart';
import 'package:syspig/services/prefs_service.dart';

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
    String? accessToken = await PrefsService.getAuthToken();

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {

        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        
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
