import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/model/usuario_model.dart';

class AnotacaoModel {
  final int? id;
  final FazendaModel? fazenda;
  final String? descricao;
  final AnimalModel? animal;
  final BaiaModel? baia;
  final DateTime? data;
  final OcupacaoModel? ocupacao;
  final UsuarioModel? createdBy;

  AnotacaoModel({
    this.id,
    this.fazenda,
    this.descricao,
    this.animal,
    this.baia,
    this.data,
    this.ocupacao,
    this.createdBy,
  });

  factory AnotacaoModel.fromJson(Map<String, dynamic> json) {
    return AnotacaoModel(
      id: json['id'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      descricao: json['descricao'],
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
      baia: json['baia'] != null ? BaiaModel.fromJson(json['baia']) : null,
      data: json['data'] != null ? DateTime.parse(json['data']) : null,
      ocupacao: json['ocupacao'] != null ? OcupacaoModel.fromJson(json['ocupacao']) : null,
      createdBy: json['createdBy'] != null ? UsuarioModel.fromJson(json['createdBy']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fazenda_id': fazenda?.id,
      'descricao': descricao,
      'animal_id': animal?.id,
      'baia_id': baia?.id,
      'ocupacao_id': ocupacao?.id,
      'data': data?.toIso8601String(),
      'created_by': createdBy?.id,
    };
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, descricao: $descricao, animal: $animal, baia: $baia, data: $data, ocupacao: $ocupacao, createdBy: $createdBy';
  }
}
