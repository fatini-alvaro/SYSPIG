import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/lote_model.dart';

class LoteAnimalModel {
  final int? id;
  final LoteModel? lote;
  final AnimalModel? animal;

  LoteAnimalModel({
    this.id,
    this.lote,
    this.animal,
  });

   factory LoteAnimalModel.fromJson(Map<String, dynamic> json) {
    return LoteAnimalModel(
      id: json['id'],
      lote: json['lote'] != null ? LoteModel.fromJson(json['lote']) : null,
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
    );
  }

  @override
  String toString() {
    return 'id: $id, lote: $lote, animal: $animal';
  }
}
