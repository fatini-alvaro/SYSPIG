
import 'package:flutter/material.dart';
import 'package:mobile/controller/lote/lote_controller.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/lote_animal_model.dart';
import 'package:mobile/model/lote_model.dart';
import 'package:mobile/repositories/animal/animal_repository_imp.dart';
import 'package:mobile/repositories/lote/lote_repository_imp.dart';
import 'package:mobile/services/prefs_service.dart';
import 'package:mobile/utils/dialogs.dart';


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
    _animaisSelecionados.clear();
    _animaisSelecionados.addAll(
      (lote.loteAnimais ?? []).map((loteAnimal) => loteAnimal.animal!)
    );
    notifyListeners();
  }

  Future<bool> create(BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Lote');

    try {

      List<LoteAnimalModel> loteAnimais = _animaisSelecionados
          .map((animal) => LoteAnimalModel(animal: animal))
          .toList();

      LoteModel novoLote = await LoteModel(
        numeroLote: _numero,
        descricao: _descricao,
        loteAnimais: loteAnimais
      );

      LoteModel loteCriado = await _loteController.create(context, novoLote);

      Dialogs.hideLoading(context);

      if (loteCriado != null) {
        Dialogs.successToast(context, 'Lote criado com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao criar Lote');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao criar a Lote');
    }

    return true;
  }

  Future<List<AnimalModel>> getAnimaisFromRepository() async {
    try {

      var idFazenda = await PrefsService.getFazendaId();

      return await _animalRepository.getList(idFazenda!); 
    } catch (e) {
      print('Erro ao buscar as animais do repositório: $e');
      throw Exception('Erro ao buscar os animais');
    }
  }

  Future<bool> update(BuildContext context, LoteModel lote) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Novo Lote');

    try {

      List<LoteAnimalModel> loteAnimais = _animaisSelecionados
          .map((animal) => LoteAnimalModel(animal: animal))
          .toList();

      LoteModel loteEdicao = await LoteModel(
        id: lote.id,
        descricao: _descricao,
        numeroLote: _numero,
        loteAnimais: loteAnimais
      );

      LoteModel loteEditado = await _loteController.update(context, loteEdicao);

      Dialogs.hideLoading(context);

      if (loteEditado != null) {
        Dialogs.successToast(context, 'Lote editada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao editar a Lote');
      }
    } catch (e) {
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao editar a Lote');
    }

    return true;
  }
}