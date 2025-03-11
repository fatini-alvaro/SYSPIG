import 'package:flutter/material.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/repositories/fazenda/fazenda_repository.dart';
import 'package:syspig/services/prefs_service.dart';

class FazendaController {
  final FazendaRepository _fazendaRepository;
  FazendaController(this._fazendaRepository);

  ValueNotifier<List<FazendaModel>> fazendas = ValueNotifier<List<FazendaModel>>([]);

  fetch(int userId) async {
    fazendas.value = await _fazendaRepository.getList(userId);
  }

  Future<FazendaModel> create(FazendaModel fazendaNova) async {

    FazendaModel novaFazenda= await  _fazendaRepository.create(fazendaNova);

    return novaFazenda;
  }

  selecionaFazenda(FazendaModel fazenda) async {
    await PrefsService.setFazenda(fazenda);
  }
}