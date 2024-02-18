import 'package:flutter/material.dart';
import 'package:mobile/model/lote_model.dart';
import 'package:mobile/repositories/lote/lote_repository.dart';

class LoteController {
  final LoteRepository _loteRepository;
  LoteController(this._loteRepository);

  ValueNotifier<List<LoteModel>> lotes = ValueNotifier<List<LoteModel>>([]);

  fetch() async {
    lotes.value = await _loteRepository.getList();
  }

  Future<bool> create (BuildContext context) async {

    return true;
  }
}