
import 'package:flutter/material.dart';
import 'package:syspig/controller/baia/baia_controller.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/granja/granja_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/dialogs.dart';


class CadastrarBaiaController with ChangeNotifier {

  final BaiaController _baiaController = BaiaController(BaiaRepositoryImp());
  final GranjaRepositoryImp _granjaRepository = GranjaRepositoryImp();

  String? _numero;
  setNumero(String value) => _numero = value;
  String? get numero => _numero;

  GranjaModel? _granja;
  void setGranja(GranjaModel? value) => _granja = value;
  GranjaModel? get granja => _granja;

  String? _capacidade;
  setCapacidade(String value) => _capacidade = value;

  Future<bool> create(BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Baia');

    try {
      BaiaModel novaBaia = await BaiaModel(
        numero: _numero!,
        granja: _granja!,
        vazia: true
      );

      BaiaModel baiaCriada = await _baiaController.create(context, novaBaia);

      Dialogs.hideLoading(context);

      if (baiaCriada != null) {
        Dialogs.successToast(context, 'Baia criada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao criar a Baia');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao criar a Baia');
    }

    return true;
  }

  Future<List<GranjaModel>> getGranjasFromRepository() async {
    try {

      var idFazenda = await PrefsService.getFazendaId();

      return await _granjaRepository.getList(idFazenda!); 
    } catch (e) {
      print('Erro ao buscar as granjas do repositório: $e');
      throw Exception('Erro ao buscar as granjas');
    }
  }

  Future<bool> update(BuildContext context, BaiaModel baia) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Nova Granja');

    try {
      BaiaModel baiaEdicao = await BaiaModel(
        id: baia.id,
        numero: _numero!,
        granja: _granja!,
        fazenda: baia.fazenda,
        vazia: true
      );

      BaiaModel baiaEditada = await _baiaController.update(context, baiaEdicao);

      Dialogs.hideLoading(context);

      if (baiaEditada != null) {
        Dialogs.successToast(context, 'Baia editada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao editada a Baia');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao editar a Baia');
    }

    return true;
  }
}