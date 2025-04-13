import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/ocupacao_animal_model.dart';
import 'package:syspig/model/usuario_model.dart';

class AnimalModel {
  final int? id;
  final String? numeroBrinco;
  final FazendaModel? fazenda;
  final SexoAnimal? sexo;
  final StatusAnimal? status;
  final DateTime? dataNascimento;
  final UsuarioModel? createdBy;
  final DateTime? createdAt;
  final UsuarioModel? updatedBy;
  final DateTime? updatedAt;
  final OcupacaoAnimalModel? ocupacaoAnimalAtiva;
  final bool? nascimento;

  AnimalModel({
    this.id,
    this.numeroBrinco,
    this.fazenda,
    this.sexo,
    this.status,
    this.dataNascimento,
    this.ocupacaoAnimalAtiva,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.nascimento,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['id'],
      numeroBrinco: json['numero_brinco'],
      sexo: sexoFromApi(json['sexo']),
      status: intToStatusAnimal[json['status']] ?? StatusAnimal.vivo,
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      dataNascimento: json['data_nascimento'] != null ? DateTime.parse(json['data_nascimento']) : null,
      ocupacaoAnimalAtiva: json['ocupacao_animal_ativa'] != null ? OcupacaoAnimalModel.fromJson(json['ocupacao_animal_ativa']) : null,
      createdBy: json['createdBy'] != null ? UsuarioModel.fromJson(json['createdBy']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedBy: json['updatedBy'] != null ? UsuarioModel.fromJson(json['updatedBy']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      nascimento: json['nascimento'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_brinco': numeroBrinco,
      'sexo': sexo?.toShortString(),
      'status': statusAnimalToInt[status],
      'fazenda_id': fazenda?.id,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'created_by': createdBy?.id,
      'created_at': createdAt?.toIso8601String(),
      'updated_by': updatedBy?.id,
      'updated_at': updatedAt?.toIso8601String(),
      'nascimento': nascimento,
    };
  }

  @override
  String toString() {
    return 'id: $id, numero_brinco: $numeroBrinco, sexo: ${sexoAnimalDescriptions[sexo]}, status: ${statusAnimalDescriptions[status]}, fazenda: $fazenda, data_nascimento: $dataNascimento, createdBy: $createdBy, created_at: $createdAt, updatedBy: $updatedBy, updated_at: $updatedAt, ocupacao_animal_ativa: $ocupacaoAnimalAtiva, nascimento: $nascimento';
  }
}