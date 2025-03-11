
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/controller/fazenda/fazenda_controller.dart';
import 'package:syspig/model/cidade_model.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/repositories/cidade/cidade_repository_imp.dart';
import 'package:syspig/repositories/fazenda/fazenda_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';
import 'package:syspig/utils/dialogs.dart';


class CadastrarFazendaController with ChangeNotifier {

  final FazendaController _fazendaController 
      = FazendaController(FazendaRepositoryImp());
  
  final CidadeRepositoryImp _cidadeRepository = CidadeRepositoryImp();

  String? _nome;
  setNome(String value) => _nome = value;
  String? get nome => _nome;

  CidadeModel? _cidade;
  void setCidade(CidadeModel? value) {
    _cidade = value;
    notifyListeners();
  }
  CidadeModel? get cidade => _cidade;

  Future<FazendaModel> createFazenda() async {
    return FazendaModel(
      nome: _nome!,
      cidade: _cidade,
    );
  }

  Future<bool> create(BuildContext context) async {
    final fazendaCriada = await AsyncHandler.execute(
      context: context,
      action: () async {
        final novaFazenda = await createFazenda();
        return await _fazendaController.create(novaFazenda);
      },
      loadingMessage: 'Aguarde, Criando nova Fazenda',
      successMessage: 'Fazenda criada com sucesso!',
    );

    return fazendaCriada != null;
  }

  Future<List<CidadeModel>> getCidadesFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        return await _cidadeRepository.getList(); 
      },
      errorMessage: 'Erro ao buscar as cidades do repositório',
    ) ?? [];
  }
}