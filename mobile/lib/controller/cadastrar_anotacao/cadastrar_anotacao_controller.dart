
import 'package:flutter/material.dart';
import 'package:syspig/controller/anotacao/anotacao_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/anotacao/anotacao_repository_imp.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/dialogs.dart';


class CadastrarAnotacaoController with ChangeNotifier {

  final AnotacaoController _anotacaoController = AnotacaoController(AnotacaoRepositoryImp());
  final AnimalRepositoryImp _animalRepository = AnimalRepositoryImp();
  final BaiaRepositoryImp _baiaRepository = BaiaRepositoryImp();

  BaiaModel? _baia;
  void setBaia(BaiaModel? value) => _baia = value;
  BaiaModel? get baia => _baia;

  AnimalModel? _animal;
  void setAnimal(AnimalModel? value) => _animal = value;
  AnimalModel? get animal => _animal;

  String? _descricao;
  setDescricao(String value) => _descricao = value;
  String? get descricao => _descricao;

  Future<bool> create(BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Anotação');

    try {
      AnotacaoModel novaAnotacao = await AnotacaoModel(
        animal: _animal,
        baia: _baia,
        descricao: _descricao 
      );

      AnotacaoModel anotacaoCriada = await _anotacaoController.create(context, novaAnotacao);

      Dialogs.hideLoading(context);

      if (anotacaoCriada != null) {
        Dialogs.successToast(context, 'Anotação criada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao criar a Anotação');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao criar a Anotação');
    }

    return true;
  }

  Future<bool> update(BuildContext context, AnotacaoModel anotacao) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Nova Granja');

    try {
      AnotacaoModel anotacaoEdicao = await AnotacaoModel(
        id: anotacao.id,
        descricao: _descricao,
        animal: _animal,
        baia: _baia
      );

      AnotacaoModel anotacaoEditada= await _anotacaoController.update(context, anotacaoEdicao);

      Dialogs.hideLoading(context);

      if (anotacaoEditada != null) {
        Dialogs.successToast(context, 'Anotação editada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao editar a Anotação');
      }
    } catch (e) {
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao editar a Anotação');
    }

    return true;
  }

  Future<List<AnimalModel>> getAnimaisFromRepository() async {
    try {

      var idFazenda = await PrefsService.getFazendaId();

      return await _animalRepository.getList(idFazenda!); 
    } catch (e) {
      print('Erro ao buscar as animais do repositório: $e');
      throw Exception('Erro ao buscar os animais');
    }
  }

  Future<List<BaiaModel>> getBaiasFromRepository() async {
    try {

      var idFazenda = await PrefsService.getFazendaId();

      return await _baiaRepository.getListAll(idFazenda!); 
    } catch (e) {
      print('Erro ao buscar as animais do repositório: $e');
      throw Exception('Erro ao buscar os animais');
    }
  }
}