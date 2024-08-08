import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/fazenda_model.dart';

class InseminacaoModel {
  final int id;
  final FazendaModel? fazenda;
  final AnimalModel? animal;

  InseminacaoModel({
    required this.id,
    this.fazenda,
    this.animal,
  });

  factory InseminacaoModel.fromJson(Map<String, dynamic> json) {
    return InseminacaoModel(
      id: json['id'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
    );
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, animal: $animal';
  }
}
