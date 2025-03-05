import 'package:logger/logger.dart';

class AsyncFetcher {
  static Future<T?> fetch<T>({
    required Future<T> Function() action,
    String errorMessage = 'Erro ao buscar os dados',
  }) async {
    try {
      return await action();
    } catch (e) {
      Logger().e('$errorMessage: $e');
      return null;
    }
  }
}
