import 'package:flutter/material.dart';

class GestacaoInfo {
  final int diasDesdeInseminacao;
  final int diasFaltando;
  final DateTime dataPrevistaParto;
  final Color corStatus;

  GestacaoInfo({
    required this.diasDesdeInseminacao,
    required this.diasFaltando,
    required this.dataPrevistaParto,
    required this.corStatus,
  });
}

class GestacaoUtil {
  static const int diasGestacao = 114;

  static GestacaoInfo calcularInfoGestacao(DateTime dataInseminacao) {
    final hoje = DateTime.now();
    final dataParto = dataInseminacao.add(const Duration(days: diasGestacao));
    final diasDesdeInseminacao = hoje.difference(dataInseminacao).inDays;
    final diasFaltando = dataParto.difference(hoje).inDays;

    Color cor;
    if (diasFaltando < 0) {
      cor = Colors.grey; // Já deveria ter parido
    } else if (diasFaltando < 7) {
      cor = Colors.red;
    } else if (diasFaltando < 14) {
      cor = Colors.amber;
    } else {
      cor = Colors.orange;
    }

    return GestacaoInfo(
      diasDesdeInseminacao: diasDesdeInseminacao,
      diasFaltando: diasFaltando,
      dataPrevistaParto: dataParto,
      corStatus: cor,
    );
  }
}
