import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/model/ocupacao_model.dart';

class BaiaModel {
  final int? id;
  final FazendaModel? fazenda;
  final GranjaModel granja;
  final OcupacaoModel? ocupacao;
  final String numero;
  final int? capacidade;
  final bool vazia;

  BaiaModel({
    this.id,
    this.fazenda,
    required this.granja,
    this.ocupacao,
    required this.numero,
    this.capacidade,
    required this.vazia,
  });

  factory BaiaModel.fromJson(Map<String, dynamic> json) {
    return BaiaModel(
      id: json['id'],
      fazenda: FazendaModel.fromJson(json['fazenda']),
      granja: GranjaModel.fromJson(json['granja']),
      ocupacao: json['ocupacao'] != null ? OcupacaoModel.fromJson(json['ocupacao']) : null,
      numero: json['numero'],
      capacidade: json['capacidade'],
      vazia: json['vazia'],
    );
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, granja: $granja, ocupacao: $ocupacao, numero: $numero, capacidade: $capacidade, vazia: $vazia';
  }
}
