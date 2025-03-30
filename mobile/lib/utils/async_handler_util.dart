import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syspig/utils/dialogs.dart';

class AsyncHandler {
  static Future<T?> execute<T>({
    required BuildContext context,
    required Future<T> Function() action,
    required String loadingMessage,
    String successMessage = '',
  }) async {
    Dialogs.showLoading(context, message: loadingMessage);

    try {
      final result = await action();

      Dialogs.hideLoading(context);

      if (result != null && successMessage.isNotEmpty) {
        Dialogs.successToast(context, successMessage);
      }

      return result;
    } on DioException catch (e) {
      // Tratamento específico para erros Dio
      Dialogs.hideLoading(context);
      
      String errorMessage = 'Erro desconhecido';
      
      // Tenta extrair a mensagem do response
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        final responseData = e.response!.data as Map<String, dynamic>;
        errorMessage = responseData['message'] ?? 'Erro na operação';
      } else {
        errorMessage = e.message ?? 'Erro na requisição';
      }
      
      Dialogs.errorToast(context, errorMessage);
      return null;
    } catch (e) {
      // Tratamento para outros tipos de erro
      Dialogs.hideLoading(context);
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      Dialogs.errorToast(context, 'Erro: $errorMessage');
      return null;
    }
  }
}
