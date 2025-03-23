import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/ocupacao_model.dart';

class OcupacaoAnimalModel {
  final int? id;
  final OcupacaoModel? ocupacao;
  final AnimalModel? animal;

  OcupacaoAnimalModel({
    this.id,
    this.ocupacao,
    this.animal,
  });

   factory OcupacaoAnimalModel.fromJson(Map<String, dynamic> json) {
    return OcupacaoAnimalModel(
      id: json['id'],
      ocupacao: json['ocupacao'] != null ? OcupacaoModel.fromJson(json['ocupacao']) : null,
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ocupacao_id': ocupacao?.id,
      'animal_id': animal?.id,
    };
  }

  @override
  String toString() {
    return 'id: $id, ocupacao: $ocupacao, animal: $animal';
  }
}
