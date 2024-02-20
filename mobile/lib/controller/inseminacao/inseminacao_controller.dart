import 'package:flutter/material.dart';
import 'package:mobile/model/inseminacao_model.dart';
import 'package:mobile/repositories/iseminacao/inseminacao_repository.dart';

class InseminacaoController {
  final InseminacaoRepository _inseminacaoRepository;
  InseminacaoController(this._inseminacaoRepository);

  ValueNotifier<List<InseminacaoModel>> inseminacoes = ValueNotifier<List<InseminacaoModel>>([]);

  fetch() async {
    inseminacoes.value = await _inseminacaoRepository.getList();
  }

  Future<bool> create (BuildContext context) async {

    return true;
  }
}