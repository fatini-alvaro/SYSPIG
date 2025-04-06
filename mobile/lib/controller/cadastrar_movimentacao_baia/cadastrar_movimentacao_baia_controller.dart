// lib/controller/movimentacao_baia/movimentacao_baia_controller.dart
import 'package:flutter/material.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';
import 'package:syspig/widgets/custom_add_movimentacao_baia_widget.dart';

class MovimentacaoBaiaController with ChangeNotifier {
  final BaiaRepositoryImp _baiaRepository = BaiaRepositoryImp();
  final OcupacaoRepositoryImp _ocupacaoRepository = OcupacaoRepositoryImp();

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

  Future<bool> movimentarAnimais(BuildContext context, List<AnimalModel> animais, MovimentacaoTipo tipo, BaiaModel? baiaSelecionada, Map<AnimalModel, BaiaModel> animalBaiaMap) async {
    List<Map<String, dynamic>> movimentacoes = [];

    // Lógica para gerar as movimentações de acordo com o tipo selecionado
    switch (tipo) {
      case MovimentacaoTipo.todosParaMesmaBaia:
      case MovimentacaoTipo.selecionarIndividualmente:
        if (baiaSelecionada != null) {
          for (var animal in animais) {
            movimentacoes.add({
              'animal_id': animal.id as int,
              'baia_destino_id': baiaSelecionada.id as int,
            });
          }
        }
        break;

      case MovimentacaoTipo.cadaParaBaiaDiferente:
        for (var animal in animais) {
          if (animalBaiaMap.containsKey(animal)) {
            var baiaDestino = animalBaiaMap[animal];
            if (baiaDestino != null) {
              movimentacoes.add({
                'animal_id': animal.id,
                'baia_destino_id': baiaDestino.id,
              });
            }
          }
        }
        break;
    }

    // Verificando se a lista de movimentações não está vazia e fazendo a movimentação
    if (movimentacoes.isNotEmpty) {
      final movimentacaoRealizada = await AsyncHandler.execute(
        context: context,
        action: () async {
          return await _ocupacaoRepository.movimentarAnimais(
            movimentacoes: movimentacoes.map((mov) => mov.map((key, value) => MapEntry(key, value as int))).toList(),
          );
        },
        loadingMessage: 'Aguarde, realizando movimentação',
        successMessage: 'Movimentação criada com sucesso!',
      );

      return movimentacaoRealizada != null;
    } else {
      return false;
    }
  }
}