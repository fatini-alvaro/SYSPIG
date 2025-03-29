import 'package:flutter/material.dart';
import 'package:syspig/model/movimentacao_model.dart';
import 'package:syspig/repositories/movimentacao/movimentacao_repository.dart';

class MovimentacaoController {
  final MovimentacaoRepository _movimentacaoRepository;
  MovimentacaoController(this._movimentacaoRepository);

  ValueNotifier<List<MovimentacaoModel>> movimentacoes = ValueNotifier<List<MovimentacaoModel>>([]);

  fetch(int fazendaId) async {
    movimentacoes.value = await _movimentacaoRepository.getList(fazendaId);
  }

  
}