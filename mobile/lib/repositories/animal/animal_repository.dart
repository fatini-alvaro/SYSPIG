import 'package:mobile/model/animal_model.dart';

abstract class AnimalRepository {

  Future<List<AnimalModel>> getList(int fazendaId);

  Future<AnimalModel> create(AnimalModel animal);

  Future<AnimalModel> update(AnimalModel animal);

  Future<bool> delete(int animald);
}