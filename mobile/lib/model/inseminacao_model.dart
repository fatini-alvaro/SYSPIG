import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/lote_animal_model.dart';
import 'package:syspig/model/usuario_model.dart';

class InseminacaoModel {
  final int? id;
  final AnimalModel? porcoDoador;
  final AnimalModel? porcaInseminada;
  final DateTime? data;
  final LoteAnimalModel? loteAnimal;
  final BaiaModel? baia;
  final UsuarioModel? createdBy;
  final DateTime? createdAt;
  final UsuarioModel? updatedBy;
  final DateTime? updatedAt;

  InseminacaoModel({
    required this.id,
    this.porcaInseminada,
    this.porcoDoador,
    this.data,
    this.loteAnimal,
    this.baia,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory InseminacaoModel.fromJson(Map<String, dynamic> json) {
    return InseminacaoModel(
      id: json['id'],
      porcoDoador: json['porco_doador'] != null ? AnimalModel.fromJson(json['porco_doador']) : null,
      porcaInseminada: json['porca_inseminada'] != null ? AnimalModel.fromJson(json['porca_inseminada']) : null,
      data: json['data'] != null ? DateTime.parse(json['data']) : null,
      loteAnimal: json['lote_animal'] != null ? LoteAnimalModel.fromJson(json['lote_animal']) : null,
      baia: json['baia'] != null ? BaiaModel.fromJson(json['baia']) : null,
      createdBy: json['createdBy'] != null ? UsuarioModel.fromJson(json['createdBy']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedBy: json['updatedBy'] != null ? UsuarioModel.fromJson(json['updatedBy']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'porco_doador_id': porcoDoador?.id,
      'porca_inseminada_id': porcaInseminada?.id,
      'data': data?.toIso8601String(),
      'lote_animal_id': loteAnimal?.id,
      'baia_id': baia?.id,
    };
  }

  @override
  String toString() {
    return 'id: $id, porcoDoador: $porcoDoador, porcaInseminada: $porcaInseminada, data: $data, loteAnimal: $loteAnimal, baia: $baia, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt';
  }
}
