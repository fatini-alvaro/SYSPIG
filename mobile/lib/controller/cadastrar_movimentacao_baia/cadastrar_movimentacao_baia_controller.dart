// lib/controller/movimentacao_baia/movimentacao_baia_controller.dart
import 'package:flutter/material.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';

class MovimentacaoBaiaController with ChangeNotifier {
  final BaiaRepositoryImp _baiaRepository = BaiaRepositoryImp();

  List<BaiaModel> _baias = [];
  List<BaiaModel> get baias => _baias;

  BaiaModel? _selectedBaia;
  BaiaModel? get selectedBaia => _selectedBaia;
  set selectedBaia(BaiaModel? value) {
    _selectedBaia = value;
    notifyListeners();
  }

  List<AnimalModel> _selectedAnimals = [];
  List<AnimalModel> get selectedAnimals => _selectedAnimals;

  bool _isBaiaSearchFocused = false;
  bool get isBaiaSearchFocused => _isBaiaSearchFocused;

  void toggleAnimalSelection(AnimalModel animal) {
    if (_selectedAnimals.contains(animal)) {
      _selectedAnimals.remove(animal);
    } else {
      _selectedAnimals.add(animal);
    }
    notifyListeners();
  }

  Map<AnimalModel, BaiaModel> _animalBaiaMap = {};
  Map<AnimalModel, BaiaModel> get animalBaiaMap => _animalBaiaMap;

  void setAnimalBaia(AnimalModel animal, BaiaModel? baia) {
    if (baia == null) {
      _animalBaiaMap.remove(animal);
    } else {
      _animalBaiaMap[animal] = baia;
    }
    notifyListeners();
  }

  Future<void> loadBaias() async {
    final fazendaId = await PrefsService.getFazendaId();
    if (fazendaId != null) {
      _baias = await AsyncFetcher.fetch(
        action: () => _baiaRepository.getListAll(fazendaId),
        errorMessage: 'Erro ao carregar baias',
      ) ?? [];
      notifyListeners();
    }
  }

  Future<void> filterBaias(String searchTerm) async {
    if (searchTerm.isEmpty) {
      await loadBaias();
    } else {
      _baias = _baias.where((baia) => 
        (baia.numero ?? '').toLowerCase().contains(searchTerm.toLowerCase())
      ).toList();
      notifyListeners();
    }
  }

  void toggleBaiaSearchFocus() {
    _isBaiaSearchFocused = !_isBaiaSearchFocused;
    notifyListeners();
  }

  void clearBaiaSearch() {
    _isBaiaSearchFocused = false;
    notifyListeners();
  }
}