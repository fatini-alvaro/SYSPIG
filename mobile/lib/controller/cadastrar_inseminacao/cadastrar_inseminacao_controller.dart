import 'package:flutter/material.dart';
import 'package:syspig/controller/inseminacao/inseminacao_controller.dart';
import 'package:syspig/enums/tipo_granja_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/inseminacao_model.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/iseminacao/inseminacao_repository_imp.dart';
import 'package:syspig/repositories/lote/lote_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';
import 'package:syspig/utils/dialogs.dart';

class CadastrarInseminacaoController with ChangeNotifier {
  final InseminacaoController _inseminacaoController = InseminacaoController(InseminacaoRepositoryImp());
  final LoteRepositoryImp _loteRepository = LoteRepositoryImp();
  final AnimalRepositoryImp _animalRepository = AnimalRepositoryImp();
  final BaiaRepositoryImp _baiaRepository = BaiaRepositoryImp();

  LoteModel? _lote;
  void setLote(LoteModel? value) {
    _lote = value;
    notifyListeners();
  }
  LoteModel? get lote => _lote;

  AnimalModel? _porco;
  void setPorco(AnimalModel? value) {
    _porco = value;
    notifyListeners();
  }
  AnimalModel? get porco => _porco;

  DateTime? _data;
  setData(DateTime? value) => _data = value;
  DateTime? get data => _data;

  BaiaModel? _baia;
  void setBaiaInseminacao(BaiaModel? value) {
    _baia = value;
    notifyListeners();
  }
  BaiaModel? get baia => _baia;

  final List<InseminacaoModel> _inseminacoes = [];
  List<InseminacaoModel> get inseminacoes => _inseminacoes;

  Future<List<LoteModel>> getLotesFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _loteRepository.getListAtivos(idFazenda!);
      },
      errorMessage: 'Erro ao buscar os lotes do repositório',
    ) ?? [];
  }

  Future<List<AnimalModel>> getPorcosFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _animalRepository.getListPorcos(idFazenda!);
      },
      errorMessage: 'Erro ao buscar os porcos do repositório',
    ) ?? [];
  }

  Future<List<BaiaModel>> getListByFazendaAndTipo() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _baiaRepository.getListByFazendaAndTipo(idFazenda!, TipoGranjaId.inseminacao);
      },
      errorMessage: 'Erro ao buscar os baias de inseminação do repositório',
    ) ?? [];
  }

  Future<bool> cadastrarInseminacoes(BuildContext context) async {
    final movimentacaoRealizada = await AsyncHandler.execute(
      context: context,
      action: () async {
        if (_inseminacoes.isEmpty) {
          throw Exception('Sem inseminações para cadastrar');
        }
        
        // Agora envia como lista, mesmo sendo apenas um
        // return await _ocupacaoRepository.movimentarAnimais(
        //   movimentacoes: [
        //     {
        //       'animal_id': _animal!.id!,
        //       'baia_destino_id': _baiaDestino!.id!,
        //     }
        //   ],
        // );
      },
      loadingMessage: 'Aguarde, realizando movimentação',
      successMessage: 'Movimentação criada com sucesso!',
    );

    return movimentacaoRealizada != null;
  }
}