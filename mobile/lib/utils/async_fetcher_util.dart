class AsyncFetcher {
  static Future<T?> fetch<T>({
    required Future<T> Function() action,
    String errorMessage = 'Erro ao buscar os dados',
  }) async {
    try {
      return await action();
    } catch (e) {
      print('$errorMessage: $e');
      return null;
    }
  }
}
