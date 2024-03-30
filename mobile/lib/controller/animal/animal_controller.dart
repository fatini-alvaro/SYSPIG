import 'package:flutter/material.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/repositories/animal/animal_repository.dart';

class AnimalController {
  final AnimalRepository _animalRepository;
  AnimalController(this._animalRepository);

  ValueNotifier<List<AnimalModel>> animais = ValueNotifier<List<AnimalModel>>([]);

  fetch(int fazendaId) async {
    animais.value = await _animalRepository.getList(fazendaId);
  }

  Future<AnimalModel> create(BuildContext context, AnimalModel animalNovo) async {
    
    AnimalModel novoAnimal = await  _animalRepository.create(animalNovo);

    return novoAnimal;
  }
  
  Future<AnimalModel> update(BuildContext context, AnimalModel animalEdicao) async {
    
    AnimalModel animalEditada = await  _animalRepository.update(animalEdicao);

    return animalEditada;
  }

  Future<bool> delete(BuildContext context, int animalExclusaoID) async {
    
    bool excluido = await  _animalRepository.delete(animalExclusaoID);

    return excluido;
  }
}