import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Dialogs {
  static bool? isLoading = false;
  static showLoading(
    BuildContext context, {
    String? message,
  }) {
    isLoading = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                      strokeWidth: 1.5,
                    ),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      // style: AppTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static hideLoading(BuildContext context) {
    if (isLoading!) {
      isLoading = false;
      Navigator.pop(context);
    }
  }

  static void _showToast(
    BuildContext context, {
    Color? backgroundColor,
    String? message,
    int? duration,
  }) {
    ToastContext().init(context);
    //Mostra o Toast
    Toast.show(
      message ?? '',
      duration: duration,
      backgroundColor: backgroundColor!,
      textStyle: TextStyle(color: Colors.white),
    );
  }

  static void infoToast(
    BuildContext context,
    String? message, {
    int? duration = 3,
  }) {
    _showToast(
      context,
      backgroundColor: Colors.blue,
      message: message,
      duration: duration,
    );
  }

  static void successToast(
    BuildContext context,
    String? message, {
    int? duration = 5,
  }) {
    _showToast(
      context,
      backgroundColor: Colors.green,
      message: message,
      duration: duration,
    );
  }

  static void warningToast(
    BuildContext context,
    String? message, {
    int? duration = 5,
  }) {
    _showToast(
      context,
      backgroundColor: Colors.yellow,
      message: message,
      duration: duration,
    );
  }

  static void errorToast(
    BuildContext context,
    String? message, {
    int? duration = 5,
  }) {
    _showToast(
      context,
      backgroundColor: Colors.red,
      message: message,
      duration: duration,
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    String? title,
    String? message,
    String? confirmButtonText = 'SIM',
    String? cancelButtonText = 'NÃO',
  }) async {
    final ThemeData themeData = Theme.of(context);
    var value = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(
            title ?? 'EATZ',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message!,
                style: themeData.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text(
                cancelButtonText!,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                confirmButtonText!,
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                // Remove o dialog
                Navigator.of(context).pop();
                value = true;
              },
            ),
          ],
        );
      },
    );
    return value;
  }
}