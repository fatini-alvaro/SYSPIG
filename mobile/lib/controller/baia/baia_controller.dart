import 'package:flutter/material.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/repositories/baia/baia_repository.dart';

class BaiaController {
  final BaiaRepository _baiaRepository;
  BaiaController(this._baiaRepository);

  ValueNotifier<List<BaiaModel>> baias = ValueNotifier<List<BaiaModel>>([]);

  fetchByGranja(int granjaId) async {
    baias.value = await _baiaRepository.getList(granjaId);
  }

  fetch(int fazendaId) async {
    baias.value = await _baiaRepository.getListAll(fazendaId);
  }

  Future<BaiaModel> fetchBaiaById(int baiaId) async {
    
    BaiaModel baia = await  _baiaRepository.getById(baiaId);

    return baia;
  }

  Future<BaiaModel> create(BaiaModel baiaNova) async {

    BaiaModel novaGranja = await  _baiaRepository.create(baiaNova);

    return novaGranja;
  }
  

  Future<BaiaModel> update(BaiaModel baiaEdicao) async {
    
    BaiaModel baiaEditada = await  _baiaRepository.update(baiaEdicao);

    return baiaEditada;
  }
}