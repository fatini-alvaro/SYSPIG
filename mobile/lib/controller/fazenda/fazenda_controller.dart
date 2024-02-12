import 'package:flutter/material.dart';
import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/repositories/fazenda_repository.dart';

class FazendaController {
  final FazendaRepository _fazendaRepository;
  FazendaController(this._fazendaRepository);

  ValueNotifier<List<FazendaModel>> fazendas = ValueNotifier<List<FazendaModel>>([]);

  fetch() async {
    fazendas.value = await _fazendaRepository.getList();
  }

  Future<bool> create (BuildContext context) async {

    return true;
  }
}