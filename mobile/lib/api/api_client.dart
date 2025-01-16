import 'package:dio/dio.dart';
import 'package:syspig/services/prefs_service.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://localhost:3000',
    );

    _dio = Dio(options);

    // Adiciona interceptors imediatamente
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = await PrefsService.getAccessToken();
        int? userId = await PrefsService.getUserId();
        int? fazendaId = await PrefsService.getFazendaId();

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
      onError: (error, handler) async {
        String? refreshToken = await PrefsService.getRefreshToken();
        if (error.response?.statusCode == 403 && refreshToken != null) {

          // Evita loops definindo um flag
          if (error.requestOptions.extra["retry"] == true) {
            return handler.next(error); // Já foi tentado, retorna o erro original
          }

          // Marca como tentativa de renovação
          error.requestOptions.extra["retry"] = true;

          // Tentativa de renovar o accessToken com o refreshToken
          try {
            var response = await _dio.post('/auth/refresh', data: {
              'refreshToken': refreshToken,
            });

            if (response.statusCode == 200) {
              // Armazena o novo accessToken
              String newAccessToken = response.data['accessToken'];
              await PrefsService.saveAccessToken(newAccessToken);

              // Repete a requisição original com o novo accessToken
              error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              
              final retryResponse = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(retryResponse);
            }
          } catch (e) {
            // Caso falhe a tentativa de renovação, retorna o erro original
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: e,
                type: DioExceptionType.unknown, // Substituto para DioErrorType.other
              ),
            );
          }
        }

        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;
}
