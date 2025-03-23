import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/model/ocupacao_model.dart';

class BaiaModel {
  final int? id;
  final FazendaModel? fazenda;
  final GranjaModel? granja;
  final OcupacaoModel? ocupacao;
  final String? numero;
  final int? capacidade;
  final bool? vazia;

  BaiaModel({
    this.id,
    this.fazenda,
    this.granja,
    this.ocupacao,
    this.numero,
    this.capacidade,
    this.vazia,
  });

  factory BaiaModel.fromJson(Map<String, dynamic> json) {
    return BaiaModel(
      id: json['id'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      granja: json['granja'] != null ? GranjaModel.fromJson(json['granja']) : null,
      ocupacao: json['ocupacao'] != null ? OcupacaoModel.fromJson(json['ocupacao']) : null,
      numero: json['numero'],
      capacidade: json['capacidade'],
      vazia: json['vazia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fazenda_id': fazenda?.id,
      'granja_id': granja?.id,
      'ocupacao_id': ocupacao?.id,
      'numero': numero,
      'capacidade': capacidade,
      'vazia': vazia,
    };
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, granja: $granja, ocupacao: $ocupacao, numero: $numero, capacidade: $capacidade, vazia: $vazia';
  }
}
