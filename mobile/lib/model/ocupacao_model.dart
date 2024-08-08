import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/model/usuario_model.dart';

class OcupacaoModel {
  final int? id;
  final int? codigo;
  final String? status;
  final FazendaModel? fazenda;
  final GranjaModel? granja;
  final AnimalModel? animal;
  final BaiaModel? baia;
  final DateTime? dataAbertura;
  final UsuarioModel? createdBy;
  final DateTime? createdAt;
  final UsuarioModel? updatedBy;
  final DateTime? updatedAt;

  OcupacaoModel({
    this.id,
    this.codigo,
    this.status,
    this.fazenda,
    this.granja,
    this.animal,
    this.baia,
    this.dataAbertura,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory OcupacaoModel.fromJson(Map<String, dynamic> json) {
    return OcupacaoModel(
      id: json['id'],
      codigo: json['codigo'],
      status: json['status'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      granja: json['granja'] != null ? GranjaModel.fromJson(json['granja']) : null,
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
      baia: json['baia'] != null ? BaiaModel.fromJson(json['baia']) : null,
      dataAbertura: json['data_abertura'] != null ? DateTime.parse(json['data_abertura']) : null,
      createdBy: json['createdBy'] != null ? UsuarioModel.fromJson(json['createdBy']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedBy: json['updatedBy'] != null ? UsuarioModel.fromJson(json['updatedBy']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  @override
  String toString() {
    return 'id: $id, codigo: $codigo, status: $status, fazenda: $fazenda, granja: $granja, animal: $animal, baia: $baia, data_abertura: $dataAbertura, createdBy: $createdBy, created_at: $createdAt, updatedBy: $updatedBy, updated_at: $updatedAt';
  }
}
