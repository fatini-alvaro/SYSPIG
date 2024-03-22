import 'package:flutter/material.dart';
import 'package:mobile/model/granja_model.dart';
import 'package:mobile/repositories/granja/granja_repository.dart';

class GranjaController {
  final GranjaRepository _granjaRepository;
  GranjaController(this._granjaRepository);

  ValueNotifier<List<GranjaModel>> granjas = ValueNotifier<List<GranjaModel>>([]);

  fetch(int fazendaId) async {
    granjas.value = await _granjaRepository.getList(fazendaId);
  }

  Future<bool> create (BuildContext context) async {

    return true;
  }
}