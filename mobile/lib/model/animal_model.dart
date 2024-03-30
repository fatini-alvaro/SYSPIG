import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/model/usuario_model.dart';

class AnimalModel {
  final int? id;
  final String numeroBrinco;
  final FazendaModel? fazenda;
  final String sexo;
  final String status;
  final DateTime? dataNascimento;
  final UsuarioModel? createdBy;
  final DateTime? createdAt;
  final UsuarioModel? updatedBy;
  final DateTime? updatedAt;

  AnimalModel({
    this.id,
    required this.numeroBrinco,
    this.fazenda,
    required this.sexo,
    required this.status,
    this.dataNascimento,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['id'],
      numeroBrinco: json['numero_brinco'],
      sexo: json['sexo'],
      status: json['status'],
      fazenda: FazendaModel.fromJson(json['fazenda']),
      dataNascimento: json['data_nascimento'] != null ? DateTime.parse(json['data_nascimento']) : null,
      createdBy: json['createdBy'] != null ? UsuarioModel.fromJson(json['createdBy']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedBy: json['updatedBy'] != null ? UsuarioModel.fromJson(json['updatedBy']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  @override
  String toString() {
    return 'id: $id, numero_brinco: $numeroBrinco, sexo: $sexo, status: $status, fazenda: $fazenda, data_nascimento: $dataNascimento, createdBy: $createdBy, created_at: $createdAt, updatedBy: $updatedBy, updated_at: $updatedAt';
  }
}
