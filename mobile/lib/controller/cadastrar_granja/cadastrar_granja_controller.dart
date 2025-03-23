
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/controller/granja/granja_controller.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/model/tipo_granja_model.dart';
import 'package:syspig/repositories/granja/granja_repository_imp.dart';
import 'package:syspig/repositories/tipo_granja/tipo_granja_repository_imp.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';


class CadastrarGranjaController with ChangeNotifier {

  final GranjaController _granjaController = 
      GranjaController(GranjaRepositoryImp());

  final TipoGranjaRepositoryImp _tipoGranjaRepository = TipoGranjaRepositoryImp();

  String? _descricao;
  setDescricao(String value) => _descricao = value;
  String? get descricao => _descricao;

  TipoGranjaModel? _tipoGranja;
  void setTipoGranja(TipoGranjaModel? value) {
    _tipoGranja = value;
    notifyListeners();
  }
  TipoGranjaModel? get tipoGranja => _tipoGranja;

  Future<GranjaModel> createGranja() async {
    return GranjaModel(
      descricao: _descricao!,
      tipoGranja: _tipoGranja!,
    );
  }

  Future<bool> create(BuildContext context) async {
    final granjaCriada = await AsyncHandler.execute(
      context: context,
      action: () async {
        final novaGranja = await createGranja();
        return await _granjaController.create(novaGranja);
      },
      loadingMessage: 'Aguarde, Criando Granja',
      successMessage: 'Granja criada com sucesso!',
    );

    return granjaCriada != null;
  }

  Future<bool> update(BuildContext context, int granjaId) async {
    final granjaEditada = await AsyncHandler.execute(
      context: context,
      action: () async {
        return await _granjaController.update(
          GranjaModel(
            id: granjaId,
            descricao: _descricao!,
            tipoGranja: _tipoGranja,
          ),
        );
      },
      loadingMessage: 'Aguarde, Editando Granja',
      successMessage: 'Granja editada com sucesso!',
    );

    return granjaEditada != null;
  }

  Future<List<TipoGranjaModel>> getTipoGranjasFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        return await _tipoGranjaRepository.getList(); 
      },
      errorMessage: 'Erro ao buscar os tipos granjas',
    ) ?? [];
  }

  Future<GranjaModel?> fetchGranjaById(int granjaId) async {
    return await AsyncFetcher.fetch(
      action: () async {
        return await _granjaController.fetchGranjaById(granjaId);
      },
      errorMessage: 'Erro ao buscar granja',
    );
  }

}