import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/usuario_model.dart';

class AnimalModel {
  final int? id;
  final String numeroBrinco;
  final FazendaModel? fazenda;
  final SexoAnimal sexo;
  final StatusAnimal status;
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
      sexo: sexoFromApi(json['sexo']),
      status: intToStatusAnimal[json['status']] ?? StatusAnimal.vivo,
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      dataNascimento: json['data_nascimento'] != null ? DateTime.parse(json['data_nascimento']) : null,
      createdBy: json['createdBy'] != null ? UsuarioModel.fromJson(json['createdBy']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedBy: json['updatedBy'] != null ? UsuarioModel.fromJson(json['updatedBy']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroBrinco': numeroBrinco,
      'sexo': sexo.toShortString(),
      'status': statusAnimalToInt[status],
      'fazenda': fazenda?.toJson(),
      'dataNascimento': dataNascimento?.toIso8601String(),
      'createdBy': createdBy?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updatedBy': updatedBy?.toJson(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'id: $id, numero_brinco: $numeroBrinco, sexo: ${sexoAnimalDescriptions[sexo]}, status: ${statusAnimalDescriptions[status]}, fazenda: $fazenda, data_nascimento: $dataNascimento, createdBy: $createdBy, created_at: $createdAt, updatedBy: $updatedBy, updated_at: $updatedAt';
  }
}