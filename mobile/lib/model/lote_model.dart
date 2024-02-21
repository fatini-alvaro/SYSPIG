import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/fazenda_model.dart';

class LoteModel {
  final int id;
  final FazendaModel fazenda;
  final String numero;
  final AnimalModel animal;

  LoteModel({
    required this.id,
    required this.fazenda,
    required this.numero,
    required this.animal,
  });

  factory LoteModel.fromJson(Map<String, dynamic> json) {
    return LoteModel(
      id: json['id'],
      fazenda: FazendaModel.fromJson(json['fazenda']),
      numero: json['numero'],
      animal: AnimalModel.fromJson(json['animal']),
    );
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, numero: $numero, animal: $animal';
  }
}
