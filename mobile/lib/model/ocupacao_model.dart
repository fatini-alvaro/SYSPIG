import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/enums/ocupacao_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/granja_model.dart';
import 'package:syspig/model/ocupacao_animal_model.dart';
import 'package:syspig/model/usuario_model.dart';

class OcupacaoModel {
  final int? id;
  final int? codigo;
  final StatusOcupacao? status;
  final FazendaModel? fazenda;
  final GranjaModel? granja;
  final AnimalModel? animal;
  final BaiaModel? baia;
  final List<OcupacaoAnimalModel>? ocupacaoAnimais;
  final List<AnotacaoModel>? anotacoes;
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
    this.ocupacaoAnimais,
    this.anotacoes,
    this.dataAbertura,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  /// Lista apenas os animais da ocupação que **não são nascimentos**
  List<OcupacaoAnimalModel> get ocupacaoAnimaisSemNascimento {
    return ocupacaoAnimais
            ?.where((oa) => oa.animal?.nascimento != true)
            .toList() ??
        [];
  }

  List<OcupacaoAnimalModel> get ocupacaoAnimaisNascimento {
    final animaisNascimento = ocupacaoAnimais
            ?.where((oa) => oa.animal?.nascimento == true)
            .toList() ??
        [];

    animaisNascimento.sort((a, b) {
      final dataA = a.animal?.dataNascimento;
      final dataB = b.animal?.dataNascimento;

      if (dataA == null && dataB == null) return 0;
      if (dataA == null) return 1;
      if (dataB == null) return -1;

      final comparacaoData = dataB.compareTo(dataA); // mais novo primeiro

      if (comparacaoData != 0) return comparacaoData;

      // Critério secundário de desempate (por exemplo, pelo id do animal)
      final idA = a.animal?.id ?? 0;
      final idB = b.animal?.id ?? 0;
      return idA.compareTo(idB); // ordem crescente de ID
    });

    return animaisNascimento;
  }

  List<OcupacaoAnimalModel> get ocupacaoAnimaisNascimentoVivos {
    final animaisVivosNascimento = ocupacaoAnimais
            ?.where((oa) =>
                oa.animal?.dataNascimento != null &&
                oa.animal?.status == StatusAnimal.vivo)
            .toList() ??
        [];

    animaisVivosNascimento.sort((a, b) {
      final dataA = a.animal?.dataNascimento;
      final dataB = b.animal?.dataNascimento;

      if (dataA == null && dataB == null) return 0;
      if (dataA == null) return 1;
      if (dataB == null) return -1;

      final comparacaoData = dataB.compareTo(dataA); // mais novo primeiro

      if (comparacaoData != 0) return comparacaoData;

      final idA = a.animal?.id ?? 0;
      final idB = b.animal?.id ?? 0;
      return idA.compareTo(idB);
    });

    return animaisVivosNascimento;
  }

  factory OcupacaoModel.fromJson(Map<String, dynamic> json) {
    return OcupacaoModel(
      id: json['id'],
      codigo: json['codigo'],
      status: intToStatusOcupacao[json['status']],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      granja: json['granja'] != null ? GranjaModel.fromJson(json['granja']) : null,
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
      baia: json['baia'] != null ? BaiaModel.fromJson(json['baia']) : null,
      ocupacaoAnimais: (json['ocupacaoAnimais'] as List?)?.map((item) => OcupacaoAnimalModel.fromJson(item)).toList(),
      anotacoes: (json['anotacoes'] as List?)?.map((item) => AnotacaoModel.fromJson(item)).toList(),  
      dataAbertura: json['data_abertura'] != null ? DateTime.parse(json['data_abertura']) : null,
      createdBy: json['createdBy'] != null ? UsuarioModel.fromJson(json['createdBy']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedBy: json['updatedBy'] != null ? UsuarioModel.fromJson(json['updatedBy']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'status': statusOcupacaoToInt[status],
      'fazenda_id': fazenda?.id,
      'granja_id': granja?.id,
      'animal_id': animal?.id,
      'baia_id': baia?.id,
      'ocupacao_animais': ocupacaoAnimais?.map((ocupacaoAnimal) => ocupacaoAnimal.toJson()).toList(),
      'anotacoes': anotacoes?.map((anotacao) => anotacao.toJson()).toList(),
      'data_abertura': dataAbertura?.toIso8601String(),
      'created_by': createdBy?.id,
      'created_at': createdAt?.toIso8601String(),
      'updated_by': updatedBy?.id,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'id: $id, codigo: $codigo,  status: ${statusOcupacaoDescriptions[status]}, fazenda: $fazenda, granja: $granja, animal: $animal, baia: $baia, data_abertura: $dataAbertura, createdBy: $createdBy, created_at: $createdAt, updatedBy: $updatedBy, updated_at: $updatedAt, ocupacaoAnimais: $ocupacaoAnimais, anotacoes: $anotacoes';
  }
}
