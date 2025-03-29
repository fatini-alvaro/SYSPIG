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
        return await _baiaRepository.getListAll(idFazenda!);
      },
      errorMessage: 'Erro ao buscar as baias do repositório',
    ) ?? [];
  }

  Future<OcupacaoModel?> getOcupacaoByBaia(int baiaId) async {
    return await AsyncFetcher.fetch(
      action: () async {
        return await _ocupacaoController.fetchOcupacaoByBaia(baiaId);
      },
      errorMessage: 'Erro ao buscar ocupação da baia',
    );
  }

  Future<bool> movimentarAnimal(BuildContext context) async {
    try {
      if (_animal == null || _baiaDestino == null) {
        Dialogs.errorToast(context, 'Selecione um animal e uma baia de destino');
        return false;
      }

      // Verifica se a baia está vazia
      if (_baiaDestino!.vazia == true) {
        // Cria uma nova ocupação
        final novaOcupacao = OcupacaoModel(
          fazenda: _baiaDestino!.fazenda,
          baia: BaiaModel(
            id: _baiaDestino!.id,
            fazenda: _baiaDestino!.fazenda,
            numero: _baiaDestino!.numero,
            capacidade: _baiaDestino!.capacidade,
            vazia: _baiaDestino!.vazia,
          ),
          status: StatusOcupacao.aberto,
          ocupacaoAnimais: [
            OcupacaoAnimalModel(
              animal: AnimalModel(
                id: _animal!.id,
                fazenda: _animal!.fazenda,
                numeroBrinco: _animal!.numeroBrinco,
                sexo: _animal!.sexo,
                status: _animal!.status,
              ),
              dataEntrada: DateTime.now(),
              status: StatusOcupacaoAnimal.ativo,
            )
          ],
        );
        
        final ocupacao = await _ocupacaoController.create(novaOcupacao);
        if (ocupacao != null) {
          Dialogs.successToast(context, 'Animal movido com sucesso!');
          return true;
        } else {
          throw Exception('Erro ao criar ocupação.');
        }
      } else {
        // Verifica se já existe uma ocupação na baia
        final ocupacaoExistente = await getOcupacaoByBaia(_baiaDestino!.id!);
        
        if (ocupacaoExistente != null) {
          // Adiciona o animal à ocupação existente
          final ocupacaoAtualizada = await _ocupacaoRepository.addAnimalToOcupacao(
            ocupacaoExistente.id!,
            _animal!.id!
          );

          if (ocupacaoAtualizada != null) {
            Dialogs.successToast(context, 'Animal movido com sucesso!');
            return true;
          } else {
            throw Exception('Erro ao adicionar animal à ocupação.');
          }
        } else {
          throw Exception('Erro ao buscar ocupação da baia.');
        }
      }
    } catch (e) {
      Dialogs.errorToast(context, e.toString());
      return false;
    }
  }
}