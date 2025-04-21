import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/repositories/animal/animal_repository.dart';

class AnimalController {
  final AnimalRepository _animalRepository;
  AnimalController(this._animalRepository);

  ValueNotifier<List<AnimalModel>> animais = ValueNotifier<List<AnimalModel>>([]);

  fetch(int fazendaId) async {
    animais.value = await _animalRepository.getListLiveAndDie(fazendaId);
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
    try {
      return await _animalRepository.delete(animalExclusaoID);
    } catch (e) {
      Logger().e('Erro ao excluir animal: $e');
      rethrow;
    }
  }

  Future<bool> createNascimentos({
    required DateTime data,
    required int quantidade,
    required StatusAnimal status,
    required BaiaModel baia,
    required int matrizId,
    }) 
    async {

    bool criouNascimentos = await  _animalRepository.adicionarNascimentos(
      dataNascimento: data,
      status: status,
      quantidade: quantidade,
      baiaId: baia.id!,
      matrizId: matrizId,
    );

    return criouNascimentos;
  }

  Future<bool> deleteNascimento(int animalExclusaoID) async {
    try {
      return await _animalRepository.deleteNascimento(animalExclusaoID);
    } catch (e) {
      Logger().e('Erro ao excluir animal: $e');
      rethrow;
    }
  }

  Future<bool> atualizarStatusNascimento(int id, StatusAnimal novoStatus) async {
    try {
      return await _animalRepository.updateStatusNascimento(id, novoStatus);
    } catch (e) {
      Logger().e('Erro ao editar status do animal: $e');
      rethrow;
    }
  }

}