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
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Erro: $errorMessage');
      return null;
    }
  }
}
