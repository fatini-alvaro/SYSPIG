import 'package:flutter/material.dart';

// Método para exibir um alerta de sucesso com título e conteúdo personalizados
void showSuccessAlert(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o alerta
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
