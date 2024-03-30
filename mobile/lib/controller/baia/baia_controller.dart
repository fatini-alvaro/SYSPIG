import 'package:flutter/material.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/baia_model.dart';
import 'package:mobile/model/ocupacao_model.dart';
import 'package:mobile/repositories/animal/animal_repository_imp.dart';
import 'package:mobile/repositories/baia/baia_repository.dart';
import 'package:mobile/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:mobile/services/prefs_service.dart';

class BaiaController {
  final BaiaRepository _baiaRepository;
  BaiaController(this._baiaRepository);

  final AnimalRepositoryImp _animalRepository = AnimalRepositoryImp();
  final OcupacaoRepositoryImp _ocupacaoRepository = OcupacaoRepositoryImp();

  ValueNotifier<List<BaiaModel>> baias = ValueNotifier<List<BaiaModel>>([]);

  AnimalModel? _animal;
  void setAnimal(AnimalModel? value) => _animal = value;
  AnimalModel? get animal => _animal;

  fetch(int granjaId) async {
    baias.value = await _baiaRepository.getList(granjaId);
  }

  Future<BaiaModel> create(BuildContext context, BaiaModel baiaNova) async {

    BaiaModel novaGranja = await  _baiaRepository.create(baiaNova);

    return novaGranja;
  }

  Future<BaiaModel> update(BuildContext context, BaiaModel baiaEdicao) async {
    
    BaiaModel baiaEditada = await  _baiaRepository.update(baiaEdicao);

    return baiaEditada;
  }

  Future<List<AnimalModel>> getAnimaisFromRepository() async {
    try {
      var idFazenda = await PrefsService.getFazendaId();
      return await _animalRepository.getList(idFazenda!); 
    } catch (e) {
      print('Erro ao buscar as granjas do repositório: $e');
      throw Exception('Erro ao buscar as granjas');
    }
  }

  Future<OcupacaoModel> callCriarOcupacao(BaiaModel baia, AnimalModel animal) async {

    OcupacaoModel novaOcupacaoDados = await OcupacaoModel(
        animal: animal,
        baia: baia,
        granja: baia.granja
      );

    OcupacaoModel novaOcupacao = await  _ocupacaoRepository.create(novaOcupacaoDados);

    return novaOcupacao;
  }
}