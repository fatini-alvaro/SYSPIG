
import 'package:flutter/material.dart';
import 'package:syspig/controller/anotacao/anotacao_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/anotacao/anotacao_repository_imp.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';


class CadastrarAnotacaoController with ChangeNotifier {

  final AnotacaoController _anotacaoController =
      AnotacaoController(AnotacaoRepositoryImp());
  
  final AnimalRepositoryImp _animalRepository = AnimalRepositoryImp();
  final BaiaRepositoryImp _baiaRepository = BaiaRepositoryImp();
  final OcupacaoRepositoryImp _ocupacaoRepository = OcupacaoRepositoryImp();

  BaiaModel? _baia;
   void setBaia(BaiaModel? value) {
    _baia = value;
    notifyListeners();
  }
  BaiaModel? get baia => _baia;

  AnimalModel? _animal;
  void setAnimal(AnimalModel? value) {
    _animal = value;
    notifyListeners();
  }
  AnimalModel? get animal => _animal;

  OcupacaoModel? _ocupacao;
   void setOcupacao(OcupacaoModel? value) {
    _ocupacao = value;
    notifyListeners();
  }
  OcupacaoModel? get ocupacao => _ocupacao;

  String? _descricao;
  setDescricao(String value) => _descricao = value;
  String? get descricao => _descricao;

  DateTime? _data;
  setData(DateTime? value) => _data = value;
  DateTime? get data => _data;

  Future<AnotacaoModel> createAnotacao() async {
    return AnotacaoModel(
      descricao: _descricao,
      animal: _animal,
      baia: _baia,
      ocupacao: _ocupacao,
      data: _data,
    );
  }

  Future<bool> create(BuildContext context) async {
    final anotacaoCriada = await AsyncHandler.execute(
      context: context,
      action: () async {
        final novaAnotacao = await createAnotacao();
        return await _anotacaoController.create(novaAnotacao);
      },
      loadingMessage: 'Aguarde, Criando Anotação',
      successMessage: 'Anotação criada com sucesso!',
    );

    return anotacaoCriada != null;
  }

  Future<bool> update(BuildContext context, int anotacaoId) async {
    final anotacaoEditada = await AsyncHandler.execute(
      context: context,
      action: () async {
        return await _anotacaoController.update(
          AnotacaoModel(
            id: anotacaoId,
            descricao: _descricao,
            animal: _animal,
            baia: _baia,
            ocupacao: _ocupacao,
            data: _data,
          ),
        );
      },
      loadingMessage: 'Aguarde, Editando Anotação',
      successMessage: 'Anotação editada com sucesso!',
    );

    return anotacaoEditada != null;
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

  Future<List<BaiaModel>> getBaiasFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _baiaRepository.getListAll(idFazenda!);
      },
      errorMessage: 'Erro ao buscar as baias do repositório',
    ) ?? [];
  }

  Future<List<OcupacaoModel>> getOcupacoesFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _ocupacaoRepository.getList(idFazenda!);
      },
      errorMessage: 'Erro ao buscar as ocupações do repositório',
    ) ?? [];
  }

  Future<AnotacaoModel?> fetchAnotacaoById(int anotacaoId) async {
    return await AsyncFetcher.fetch(
      action: () async {
        return await _anotacaoController.fetchAnotacaoById(anotacaoId);
      },
      errorMessage: 'Erro ao buscar anotação',
    );
  }
}