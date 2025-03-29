import 'package:flutter/material.dart';
import 'package:syspig/controller/ocupacao/ocupacao_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';

class CadastrarMovimentacaoController with ChangeNotifier {

  final OcupacaoController _ocupacaoController =
      OcupacaoController(OcupacaoRepositoryImp());

  final AnimalRepositoryImp _animalRepository = AnimalRepositoryImp();

  AnimalModel? _animal;
  void setAnimal(AnimalModel? value) {
    _animal = value;
    notifyListeners();
  }
  AnimalModel? get animal => _animal;

  Future<List<AnimalModel>> getAnimaisFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _animalRepository.getList(idFazenda!);
      },
      errorMessage: 'Erro ao buscar os animais do repositório',
    ) ?? [];
  }

  Future<AnimalModel?> getAnimalDetalhes(int animalId) async {
    return await AsyncFetcher.fetch(
      action: () async {
        return await _animalRepository.getById(animalId);
      },
      errorMessage: 'Erro ao buscar detalhes do animal',
    );
  }
}