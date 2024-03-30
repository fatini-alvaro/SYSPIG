import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/model/granja_model.dart';

class BaiaModel {
  final int? id;
  final FazendaModel? fazenda;
  final GranjaModel granja;
  final String numero;
  final int? capacidade;
  final bool vazia;

  BaiaModel({
    this.id,
    this.fazenda,
    required this.granja,
    required this.numero,
    this.capacidade,
    required this.vazia,
  });

  factory BaiaModel.fromJson(Map<String, dynamic> json) {
    return BaiaModel(
      id: json['id'],
      fazenda: FazendaModel.fromJson(json['fazenda']),
      granja: GranjaModel.fromJson(json['granja']),
      numero: json['numero'],
      capacidade: json['capacidade'],
      vazia: json['vazia'],
    );
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, granja: $granja, numero: $numero, capacidade: $capacidade, vazia: $vazia';
  }
}
