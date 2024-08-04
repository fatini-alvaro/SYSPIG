import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/fazenda_model.dart';

class InseminacaoModel {
  final int id;
  final FazendaModel fazenda;
  final AnimalModel animal;

  InseminacaoModel({
    required this.id,
    required this.fazenda,
    required this.animal,
  });

  factory InseminacaoModel.fromJson(Map<String, dynamic> json) {
    return InseminacaoModel(
      id: json['id'],
      fazenda: FazendaModel.fromJson(json['fazenda']),
      animal: AnimalModel.fromJson(json['animal']),
    );
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, animal: $animal';
  }
}
