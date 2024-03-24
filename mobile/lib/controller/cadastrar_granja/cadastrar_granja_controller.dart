
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

  TipoGranjaModel? _tipoGranja;
  void setTipoGranja(TipoGranjaModel? value) => _tipoGranja = value;

  Future<bool> create (BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Nova Granja');

    try {
      GranjaModel novaGranja = await GranjaModel(
        descricao: _descricao!,
        tipoGranja: _tipoGranja!,
      );

      GranjaModel fazendaCriada = await _granjaController.create(context, novaGranja);

      Dialogs.hideLoading(context);

      if (fazendaCriada != null) {
        Dialogs.successToast(context, 'Fazenda criada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao criar a fazenda');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao criar a fazenda');
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