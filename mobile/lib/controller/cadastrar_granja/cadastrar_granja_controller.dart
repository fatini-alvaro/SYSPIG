
import 'package:flutter/material.dart';
import 'package:mobile/controller/granja/granja_controller.dart';
import 'package:mobile/model/granja_model.dart';
import 'package:mobile/model/tipo_granja_model.dart';
import 'package:mobile/repositories/granja/granja_repository_imp.dart';
import 'package:mobile/repositories/tipo_granja/tipo_granja_repository_imp.dart';
import 'package:mobile/utils/dialogs.dart';


class CadastrarGranjaController with ChangeNotifier {

  final GranjaController _granjaController = GranjaController(GranjaRepositoryImp());
  final TipoGranjaRepositoryImp _tipoGranjaRepository = TipoGranjaRepositoryImp();

  String? _descricao;
  setDescricao(String value) => _descricao = value;
  String? get descricao => _descricao;

  TipoGranjaModel? _tipoGranja;
  void setTipoGranja(TipoGranjaModel? value) => _tipoGranja = value;
  TipoGranjaModel? get tipoGranja => _tipoGranja;

  Future<bool> create(BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, Editando Granja');

    try {
      GranjaModel novaGranja = await GranjaModel(

        descricao: _descricao!,
        tipoGranja: _tipoGranja!,
      );

      GranjaModel granjaCriada = await _granjaController.create(context, novaGranja);

      Dialogs.hideLoading(context);

      if (granjaCriada != null) {
        Dialogs.successToast(context, 'Granja criada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao criar a Granja');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao criar a Granja');
    }

    return true;
  }

  Future<bool> update(BuildContext context, GranjaModel granja) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Nova Granja');

    try {
      GranjaModel novaGranja = await GranjaModel(
        id: granja.id,
        descricao: _descricao!,
        tipoGranja: _tipoGranja!,
      );

      GranjaModel granjaEditada = await _granjaController.update(context, novaGranja);

      Dialogs.hideLoading(context);

      if (granjaEditada != null) {
        Dialogs.successToast(context, 'Granja editada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao editada a Granja');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao editada a Granja');
    }

    return true;
  }

  Future<List<TipoGranjaModel>> getTipoGranjasFromRepository() async {
    try {
      return await _tipoGranjaRepository.getList(); 
    } catch (e) {
      print('Erro ao buscar as cidades do repositório: $e');
      throw Exception('Erro ao buscar as cidades');
    }
  }

}