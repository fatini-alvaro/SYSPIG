import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/lote_model.dart';

class LoteAnimalModel {
  final int? id;
  final LoteModel? lote;
  final AnimalModel? animal;
  final bool? inseminado;

  LoteAnimalModel({
    this.id,
    this.lote,
    this.animal,
    this.inseminado,
  });

   factory LoteAnimalModel.fromJson(Map<String, dynamic> json) {
    return LoteAnimalModel(
      id: json['id'],
      lote: json['lote'] != null ? LoteModel.fromJson(json['lote']) : null,
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
      inseminado: json['inseminado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lote_id': lote?.id,
      'animal_id': animal?.id,
      'inseminado': inseminado,
    };
  }

  @override
  String toString() {
    return 'id: $id, lote: $lote, animal: $animal, inseminado: $inseminado';
  }
}
