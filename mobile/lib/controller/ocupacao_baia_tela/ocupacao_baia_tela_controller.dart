
import 'package:flutter/material.dart';
import 'package:syspig/controller/baia/baia_controller.dart';
import 'package:syspig/controller/ocupacao/ocupacao_controller.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/utils/async_fetcher_util.dart';

class OcupacaoBaiaTelaController with ChangeNotifier {

  final OcupacaoController _ocupacaoController = OcupacaoController(OcupacaoRepositoryImp());
  final BaiaController _baiaController = BaiaController(BaiaRepositoryImp());

  Future<OcupacaoModel?> fetchOcupacaoByBaia(int ocupacaoId) async {
    return await AsyncFetcher.fetch<OcupacaoModel?>(
      action: () async {
        return await _ocupacaoController.fetchOcupacaoByBaia(ocupacaoId);
      },
      errorMessage: 'Erro ao buscar ocupação',
    );
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