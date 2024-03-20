import 'package:flutter/material.dart';
import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/repositories/fazenda/fazenda_repository.dart';

class FazendaController {
  final FazendaRepository _fazendaRepository;
  FazendaController(this._fazendaRepository);

  ValueNotifier<List<FazendaModel>> fazendas = ValueNotifier<List<FazendaModel>>([]);

  fetch(int userId) async {
    fazendas.value = await _fazendaRepository.getList(userId);
  }

  Future<FazendaModel> create(BuildContext context, FazendaModel fazendaNova) async {
    
    FazendaModel novaFazenda = await  _fazendaRepository.create(fazendaNova);

    return novaFazenda;
  }
}