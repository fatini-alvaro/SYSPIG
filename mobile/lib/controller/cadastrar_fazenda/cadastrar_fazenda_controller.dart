
import 'package:flutter/material.dart';
import 'package:syspig/controller/fazenda/fazenda_controller.dart';
import 'package:syspig/model/cidade_model.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/repositories/cidade/cidade_repository_imp.dart';
import 'package:syspig/repositories/fazenda/fazenda_repository_imp.dart';
import 'package:syspig/utils/dialogs.dart';


class CadastrarFazendaController with ChangeNotifier {

  final FazendaController _fazendaController = FazendaController(FazendaRepositoryImp());
  
  final CidadeRepositoryImp _cidadeRepository = CidadeRepositoryImp();

  String? _nome;
  setNome(String value) => _nome = value;

  CidadeModel? _cidade;
  void setCidade(CidadeModel? value) => _cidade = value;

  String getCidadeNome() {
    return _cidade?.nome ?? '';
  }

  Future<bool> create(BuildContext context) async {
    Dialogs.showLoading(context, message: 'Aguarde, Criando Nova Fazenda');

    try {
      FazendaModel novaFazenda = await FazendaModel(
        nome: _nome!,
        cidade: _cidade,
      );

      FazendaModel fazendaCriada = await _fazendaController.create(context, novaFazenda);

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

  Future<List<CidadeModel>> getCidadesFromRepository() async {
    try {
      return await _cidadeRepository.getList(); 
    } catch (e) {
      print('Erro ao buscar as cidades do repositório: $e');
      throw Exception('Erro ao buscar as cidades');
    }
  }
}