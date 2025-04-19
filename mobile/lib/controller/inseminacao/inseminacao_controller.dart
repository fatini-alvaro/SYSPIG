import 'package:flutter/material.dart';
import 'package:syspig/model/inseminacao_model.dart';
import 'package:syspig/repositories/iseminacao/inseminacao_repository.dart';

class InseminacaoController {
  final InseminacaoRepository _inseminacaoRepository;
  InseminacaoController(this._inseminacaoRepository);

  ValueNotifier<List<InseminacaoModel>> inseminacoes = ValueNotifier<List<InseminacaoModel>>([]);

  fetch() async {
    inseminacoes.value = await _inseminacaoRepository.getList();
  }

  Future<bool> inseminarAnimais({
    required List<InseminacaoModel> inseminacoes,
  }) async {
    try {
      final response = await _inseminacaoRepository.inseminarAnimais(
        inseminacoes: inseminacoes,
      );
      return response['success'];
    } catch (e) {
      return false;
    }
  }
}