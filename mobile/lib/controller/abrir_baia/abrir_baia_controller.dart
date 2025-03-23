
import 'package:flutter/material.dart';
import 'package:syspig/controller/ocupacao/ocupacao_controller.dart';
import 'package:syspig/enums/ocupacao_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_animal_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/baia/baia_repository.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';

class AbrirBaiaController with ChangeNotifier {
  
  final AnimalRepositoryImp _animalRepository = AnimalRepositoryImp();
  final BaiaRepository _baiaRepository = BaiaRepositoryImp();

  final OcupacaoController _ocupacaoController = OcupacaoController(OcupacaoRepositoryImp());

  ValueNotifier<List<BaiaModel>> baias = ValueNotifier<List<BaiaModel>>([]);

  BaiaModel? _baiaSelecionada;
  void setBaiaSelecionada(BaiaModel baia) {
    _baiaSelecionada = baia;
  }
  BaiaModel? get baiaSelecionada => _baiaSelecionada;

  final List<AnimalModel> _animaisSelecionados = [];
  List<AnimalModel> get animaisSelecionados => _animaisSelecionados;

  void adicionarAnimal(AnimalModel animal) {
    if (!_animaisSelecionados.any((a) => a.id == animal.id)) {
      _animaisSelecionados.add(animal);
      notifyListeners();
    }
  }

  void removerAnimal(AnimalModel animal) {
    _animaisSelecionados.remove(animal);
    notifyListeners();
  }

  Future<OcupacaoModel> dadosAbrirBaia() async {
    return OcupacaoModel(
      baia: _baiaSelecionada,
      status: StatusOcupacao.aberto,
      ocupacaoAnimais: _animaisSelecionados
          .map((animal) => OcupacaoAnimalModel(animal: animal))
          .toList(),
    );
  }

  fetchByGranja(int granjaId) async {
    baias.value = await AsyncFetcher.fetch(
      action: () async {
        return await _baiaRepository.getList(granjaId);
      },
      errorMessage: 'Erro ao buscar as baias do repositório',
    ) ?? [];
  }

  fetch() async {
    baias.value =  await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _baiaRepository.getListAll(idFazenda!);
      },
      errorMessage: 'Erro ao buscar as baias do repositório',
    ) ?? [];
  }

  //esse de cima tem que passar pro padrao desse metodo de baixa
  Future<OcupacaoModel> abrirBaia(BuildContext context) async {
    final novaOcupacao = await AsyncHandler.execute(
      context: context,
      action: () async {
        final novaOcupacao = await dadosAbrirBaia();
        return await _ocupacaoController.create(novaOcupacao);
      },
      loadingMessage: 'Aguarde, abrindo baia',
      successMessage: 'Baia aberta com sucesso!',
    );

    return novaOcupacao!;
  }

  Future<List<AnimalModel>> getAnimaisFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _animalRepository.getList(idFazenda!);
      },
      errorMessage: 'Erro ao buscar os animais do repositório',
    ) ?? [];
  }
}