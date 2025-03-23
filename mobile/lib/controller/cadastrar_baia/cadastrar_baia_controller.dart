
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/controller/baia/baia_controller.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/granja/granja_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';


class CadastrarBaiaController with ChangeNotifier {

  final BaiaController _baiaController = 
      BaiaController(BaiaRepositoryImp());


  final GranjaRepositoryImp _granjaRepository = GranjaRepositoryImp();

  String? _numero;
  setNumero(String value) => _numero = value;
  String? get numero => _numero;

  GranjaModel? _granja;
  void setGranja(GranjaModel? value) {
    _granja = value;
    notifyListeners();
  }
  GranjaModel? get granja => _granja;

  Future<BaiaModel> createBaia() async {
    return BaiaModel(
      numero: _numero,
      granja: _granja,
      vazia: true
    );
  }

  Future<bool> create(BuildContext context) async {
    final baiaCriada = await AsyncHandler.execute(
      context: context,
      action: () async {
        final novaBaia = await createBaia();
        return await _baiaController.create(novaBaia);
      },
      loadingMessage: 'Aguarde, Criando baia',
      successMessage: 'Baia criada com sucesso!',
    );

    return baiaCriada != null;
  }

  Future<bool> update(BuildContext context, int baiaId) async {
    final baiaEditada = await AsyncHandler.execute(
      context: context,
      action: () async {
        return await _baiaController.update(
          BaiaModel(
            id: baiaId,
            numero: _numero,
            granja: _granja,
            vazia: true
          ),
        );
      },
      loadingMessage: 'Aguarde, Editando Baia',
      successMessage: 'Baia editada com sucesso!',
    );

    return baiaEditada != null;
  }

  Future<List<GranjaModel>> getGranjasFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _granjaRepository.getList(idFazenda!);
      },
      errorMessage: 'Erro ao buscar os granjas do repositório',
    ) ?? [];
  }

  Future<BaiaModel?> fetchBaiaById(int baiaId) async {
    return await AsyncFetcher.fetch(
      action: () async {
        return await _baiaController.fetchBaiaById(baiaId);
      },
      errorMessage: 'Erro ao buscar baia',
    );
  }
}