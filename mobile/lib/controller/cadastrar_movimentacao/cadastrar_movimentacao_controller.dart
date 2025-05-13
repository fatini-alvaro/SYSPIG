import 'package:flutter/material.dart';
import 'package:syspig/controller/ocupacao/ocupacao_controller.dart';
import 'package:syspig/enums/ocupacao_constants.dart';
import 'package:syspig/enums/ocupacao_animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_animal_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';
import 'package:syspig/utils/dialogs.dart';

class CadastrarMovimentacaoController with ChangeNotifier {
  final OcupacaoController _ocupacaoController = OcupacaoController(OcupacaoRepositoryImp());
  final AnimalRepositoryImp _animalRepository = AnimalRepositoryImp();
  final BaiaRepositoryImp _baiaRepository = BaiaRepositoryImp();
  final OcupacaoRepositoryImp _ocupacaoRepository = OcupacaoRepositoryImp();

  AnimalModel? _animal;
  void setAnimal(AnimalModel? value) {
    _animal = value;
    notifyListeners();
  }
  AnimalModel? get animal => _animal;

  BaiaModel? _baiaDestino;
  void setBaiaDestino(BaiaModel? value) {
    _baiaDestino = value;
    notifyListeners();
  }
  BaiaModel? get baiaDestino => _baiaDestino;

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

  Future<List<BaiaModel>> getBaiasFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _baiaRepository.getListToTransfer(idFazenda!);
      },
      errorMessage: 'Erro ao buscar as baias do repositório',
    ) ?? [];
  }

  Future<OcupacaoModel?> getOcupacaoByBaia(int baiaId) async {
    return await AsyncFetcher.fetch(
      action: () async {
        final ocupacao = await _ocupacaoController.fetchOcupacaoByBaia(baiaId);
        if (ocupacao == null) {
          throw Exception('Ocupação não encontrada para a baia $baiaId');
        }
        return ocupacao;
      },
      errorMessage: 'Erro ao buscar ocupação da baia',
    );
  }

  Future<bool> movimentarAnimal(BuildContext context) async {
    final movimentacaoRealizada = await AsyncHandler.execute(
      context: context,
      action: () async {
        if (_animal == null || _baiaDestino == null) {
          throw Exception('Selecione um animal e uma baia de destino');
        }
        
        // Agora envia como lista, mesmo sendo apenas um
        return await _ocupacaoRepository.movimentarAnimais(
          movimentacoes: [
            {
              'animal_id': _animal!.id!,
              'baia_destino_id': _baiaDestino!.id!,
            }
          ],
        );
      },
      loadingMessage: 'Aguarde, realizando movimentação',
      successMessage: 'Movimentação criada com sucesso!',
    );

    return movimentacaoRealizada != null;
  }
}