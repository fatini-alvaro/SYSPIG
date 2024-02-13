import 'package:flutter/material.dart';
import 'package:mobile/model/anotacao_model.dart';
import 'package:mobile/repositories/anotacao/anotacao_repository.dart';

class AnotacaoController {
  final AnotacaoRepository _anotacaoRepository;
  AnotacaoController(this._anotacaoRepository);

  ValueNotifier<List<AnotacaoModel>> anotacoes = ValueNotifier<List<AnotacaoModel>>([]);

  fetch() async {
    anotacoes.value = await _anotacaoRepository.getList();
  }

  Future<bool> create (BuildContext context) async {

    return true;
  }
}