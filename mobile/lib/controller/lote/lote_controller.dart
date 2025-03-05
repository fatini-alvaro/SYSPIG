import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/repositories/lote/lote_repository.dart';

class LoteController {
  final LoteRepository _loteRepository;
  LoteController(this._loteRepository);

  ValueNotifier<List<LoteModel>> lotes = ValueNotifier<List<LoteModel>>([]);

  fetch(int fazendaId) async {
    lotes.value = await _loteRepository.getList(fazendaId);
  }

  Future<bool> delete(int loteExclusaoID) async {
    try {
      return await _loteRepository.delete(loteExclusaoID);
    } catch (e) {
      Logger().e('Erro ao excluir lote: $e');
      rethrow;
    }
  }

  Future<LoteModel> update(LoteModel loteEdicao) async {
    
    LoteModel loteEditado = await  _loteRepository.update(loteEdicao);

    return loteEditado;
  }

  Future<LoteModel> create(LoteModel loteNovo) async {

    LoteModel novoLote = await  _loteRepository.create(loteNovo);

    return novoLote;
  }

  Future<LoteModel> fetchLoteById(int loteId) async {
    
    LoteModel lote = await  _loteRepository.getById(loteId);

    return lote;
  }
}