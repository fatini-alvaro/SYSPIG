import 'package:flutter/material.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/repositories/lote/lote_repository.dart';

class LoteController {
  final LoteRepository _loteRepository;
  LoteController(this._loteRepository);

  ValueNotifier<List<LoteModel>> lotes = ValueNotifier<List<LoteModel>>([]);

  fetch(int fazendaId) async {
    lotes.value = await _loteRepository.getList(fazendaId);
  }

  Future<bool> delete(BuildContext context, int loteExclusaoID) async {
    
    bool excluido = await  _loteRepository.delete(loteExclusaoID);

    return excluido;
  }

  Future<LoteModel> update(BuildContext context, LoteModel loteEdicao) async {
    
    LoteModel loteEditado = await  _loteRepository.update(loteEdicao);

    return loteEditado;
  }

  Future<LoteModel> create(BuildContext context, LoteModel loteNovo) async {

    LoteModel novoLote = await  _loteRepository.create(loteNovo);

    return novoLote;
  }
}