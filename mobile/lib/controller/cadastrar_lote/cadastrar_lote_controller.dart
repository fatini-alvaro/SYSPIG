
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/controller/lote/lote_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/lote_animal_model.dart';
import 'package:syspig/model/lote_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/repositories/lote/lote_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';

class CadastrarLoteController with ChangeNotifier {
  
  final LoteController _loteController = LoteController(LoteRepositoryImp());
  final AnimalRepositoryImp _animalRepository = AnimalRepositoryImp();

  String? _numero;
  setNumero(String? value) => _numero = value;
  String? get numero => _numero;

  String? _descricao;
  setDescricao(String? value) => _descricao = value;
  String? get descricao => _descricao;

  final List<AnimalModel> _animaisSelecionados = [];
  List<AnimalModel> get animaisSelecionados => _animaisSelecionados;

  DateTime? _dataCriacao;
  setDataCriacao(DateTime? value) => _dataCriacao = value;
  DateTime? get dataCriacao => _dataCriacao;

  DateTime? _dataInicio;
  setDataInicio(DateTime? value) => _dataInicio = value;
  DateTime? get dataInicio => _dataInicio;

  DateTime? _dataFim;
  setDataFim(DateTime? value) => _dataFim = value;
  DateTime? get dataFim => _dataFim;

  bool? _encerrado;
  setEncerrado(bool? value) => _encerrado = value;
  bool? get encerrado => _encerrado;

  void adicionarAnimal(AnimalModel animal) {
    if (!_animaisSelecionados.any((a) => a.id == animal.id)) {
      _animaisSelecionados.add(animal);
      notifyListeners();
    }
  }

  void removerAnimal(AnimalModel animal) {
    _animaisSelecionados.remove(animal);
    notifyListeners();
  }

  Future<void> carregarLote(LoteModel lote) async {
    _numero = lote.numeroLote;
    _descricao = lote.descricao;
    _dataCriacao = lote.data;
    _dataInicio = lote.dataInicio;
    _dataFim = lote.dataFim;
    _encerrado = lote.encerrado;
    _animaisSelecionados.clear();
    _animaisSelecionados.addAll(
      (lote.loteAnimais ?? []).map((loteAnimal) => loteAnimal.animal!)
    );
    notifyListeners();
  }

  Future<LoteModel> createLote() async {
    return LoteModel(
      descricao: _descricao,
      numeroLote: _numero,
      data: _dataCriacao,
      dataInicio: _dataInicio,
      loteAnimais: _animaisSelecionados
          .map((animal) => LoteAnimalModel(animal: animal))
          .toList(),
    );
  }

  Future<bool> create(BuildContext context) async {
    final loteCriado = await AsyncHandler.execute(
      context: context,
      action: () async {
        final novoLote = await createLote();
        return await _loteController.create(novoLote);
      },
      loadingMessage: 'Aguarde, Criando Lote',
      successMessage: 'Lote criado com sucesso!',
    );

    return loteCriado != null;
  }

  Future<List<AnimalModel>> getAnimaisFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _animalRepository.getListDisponivelParaLote(idFazenda!);
      },
      errorMessage: 'Erro ao buscar os animais do repositório',
    ) ?? [];
  }

  Future<bool> update(BuildContext context, int loteId) async {
    final loteEditado = await AsyncHandler.execute(
      context: context,
      action: () async {
        return await _loteController.update(
          LoteModel(
            id: loteId,
            descricao: _descricao,
            numeroLote: _numero,
            data: _dataCriacao,
            dataInicio: _dataInicio,
            dataFim: _dataFim,
            encerrado: _encerrado,
            loteAnimais: _animaisSelecionados
                .map((animal) => LoteAnimalModel(animal: animal))
                .toList(),
          ),
        );
      },
      loadingMessage: 'Aguarde, Editando Lote',
      successMessage: 'Lote editado com sucesso!',
    );

    return loteEditado != null;
  }

  Future<LoteModel?> fetchLoteById(int loteId) async {
    return await AsyncFetcher.fetch(
      action: () async {
        return await _loteController.fetchLoteById(loteId);
      },
      errorMessage: 'Erro ao buscar lote',
    );
  }
}