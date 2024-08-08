import 'package:flutter/material.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/repositories/granja/granja_repository.dart';

class GranjaController {
  final GranjaRepository _granjaRepository;
  GranjaController(this._granjaRepository);

  ValueNotifier<List<GranjaModel>> granjas = ValueNotifier<List<GranjaModel>>([]);

  fetch(int fazendaId) async {
    granjas.value = await _granjaRepository.getList(fazendaId);
  }

  Future<GranjaModel> create(BuildContext context, GranjaModel granjaNova) async {
    
    GranjaModel novaGranja = await  _granjaRepository.create(granjaNova);

    return novaGranja;
  }
  
  Future<GranjaModel> update(BuildContext context, GranjaModel granjaEdicao) async {
    
    GranjaModel granjaEditada = await  _granjaRepository.update(granjaEdicao);

    return granjaEditada;
  }

  Future<bool> delete(BuildContext context, int granjaExclusaoID) async {
    
    bool excluido = await  _granjaRepository.delete(granjaExclusaoID);

    return excluido;
  }
}