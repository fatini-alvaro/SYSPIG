import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';

abstract class AnimalRepository {

  Future<List<AnimalModel>> getList(int fazendaId);

  Future<List<AnimalModel>> getListLiveAndDie(int fazendaId);

  Future<List<AnimalModel>> getlistNascimentos(int ocupacaoId);

  Future<AnimalModel> getById(int animald);

  Future<AnimalModel> create(AnimalModel animal);

  Future<bool> adicionarNascimentos({
    required DateTime dataNascimento,
    required StatusAnimal status,
    required int quantidade,
    required int baiaId,
  });

  Future<AnimalModel> update(AnimalModel animal);

  Future<bool> delete(int animald);

  Future<bool> deleteNascimento(int animald);

  Future<bool> updateStatusNascimento(int animald, StatusAnimal statusId);

  Future<List<AnimalModel>> getListPorcos(int fazendaId);

}