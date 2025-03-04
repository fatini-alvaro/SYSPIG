import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/repositories/granja/granja_repository.dart';

class GranjaController {
  final GranjaRepository _granjaRepository;
  GranjaController(this._granjaRepository);

  ValueNotifier<List<GranjaModel>> granjas = ValueNotifier<List<GranjaModel>>([]);

  fetch(int fazendaId) async {
    granjas.value = await _granjaRepository.getList(fazendaId);
  }

  Future<GranjaModel> create(GranjaModel granjaNova) async {
    
    GranjaModel novaGranja = await  _granjaRepository.create(granjaNova);

    return novaGranja;
  }
  
  Future<GranjaModel> update(GranjaModel granjaEdicao) async {
    
    GranjaModel granjaEditada = await  _granjaRepository.update(granjaEdicao);

    return granjaEditada;
  }

  Future<bool> delete(int granjaExclusaoID) async {
    try {
      return await _granjaRepository.delete(granjaExclusaoID);
    } catch (e) {
      Logger().e('Erro ao excluir granja: $e');
      rethrow;
    }
  }

  Future<GranjaModel> fetchGranjaById(int granjaId) async {
    
    GranjaModel granja = await  _granjaRepository.getById(granjaId);

    return granja;
  }
}