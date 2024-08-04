import 'package:flutter/material.dart';
import 'package:syspig/model/movimentacao_model.dart';
import 'package:syspig/repositories/movimentacao/movimentacao_repository.dart';

class MovimentacaoController {
  final MovimentacaoRepository _movimentacaolRepository;
  MovimentacaoController(this._movimentacaolRepository);

  ValueNotifier<List<MovimentacaoModel>> movimentacoes = ValueNotifier<List<MovimentacaoModel>>([]);

  fetch() async {
    movimentacoes.value = await _movimentacaolRepository.getList();
  }

  Future<bool> create(BuildContext context) async {
    return true;
  }
}