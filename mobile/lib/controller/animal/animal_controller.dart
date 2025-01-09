import 'package:flutter/material.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/repositories/animal/animal_repository.dart';

class AnimalController {
  final AnimalRepository _animalRepository;
  AnimalController(this._animalRepository);

  ValueNotifier<List<AnimalModel>> animais = ValueNotifier<List<AnimalModel>>([]);

  fetch(int fazendaId) async {
    animais.value = await _animalRepository.getList(fazendaId);
  }

  Future<AnimalModel> fetchAnimalById(int animalId) async {
    
    AnimalModel animal = await  _animalRepository.getById(animalId);

    return animal;
  }

  Future<AnimalModel> create(AnimalModel animalNovo) async {
    
    AnimalModel novoAnimal = await  _animalRepository.create(animalNovo);

    return novoAnimal;
  }
  
  Future<AnimalModel> update(AnimalModel animalEdicao) async {
    
    AnimalModel animalEditada = await  _animalRepository.update(animalEdicao);

    return animalEditada;
  }

  Future<bool> delete(int animalExclusaoID) async {
    
    bool excluido = await  _animalRepository.delete(animalExclusaoID);

    return excluido;
  }
}