import 'package:flutter/material.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/repositories/animal/animal_repository.dart';

class AnimalController {
  final AnimalRepository _animalRepository;
  AnimalController(this._animalRepository);

  ValueNotifier<List<AnimalModel>> animais = ValueNotifier<List<AnimalModel>>([]);

  fetch() async {
    animais.value = await _animalRepository.getList();
  }

  Future<bool> create (BuildContext context) async {

    return true;
  }
}