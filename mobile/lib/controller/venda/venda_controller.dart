import 'package:flutter/material.dart';
import 'package:syspig/model/movimentacao_model.dart';
import 'package:syspig/model/venda_model.dart';
import 'package:syspig/repositories/movimentacao/movimentacao_repository.dart';
import 'package:syspig/repositories/venda/venda_repository.dart';

class VendaController {
  final VendaRepository _vendaRepository;
  VendaController(this._vendaRepository);

  ValueNotifier<List<VendaModel>> vendas = ValueNotifier<List<VendaModel>>([]);

  fetch(int fazendaId) async {
    vendas.value = await _vendaRepository.getList(fazendaId);
  }
  
}