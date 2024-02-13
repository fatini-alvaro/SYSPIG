import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/fazenda_model.dart';

class AnotacaoModel {
  final int id;
  final FazendaModel fazenda;
  final String descricao;
  final AnimalModel animal;
  // final FazendaModel baia;
  // final TipoGranjaModel matriz;
  // final TipoGranjaModel pai;

  AnotacaoModel({
    required this.id,
    required this.fazenda,
    required this.descricao,
    required this.animal,
  });

  factory AnotacaoModel.fromJson(Map<String, dynamic> json) {
    return AnotacaoModel(
      id: json['id'],
      fazenda: json['fazenda'],
      descricao: json['descricao'],
      animal: AnimalModel.fromJson(json['animal'])
    );
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, descricao: $descricao, animal: $animal';
  }
}
