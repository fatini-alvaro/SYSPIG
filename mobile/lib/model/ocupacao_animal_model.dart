import 'package:syspig/enums/ocupacao_animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/ocupacao_model.dart';

class OcupacaoAnimalModel {
  final int? id;
  final OcupacaoModel? ocupacao;
  final AnimalModel? animal;
  final DateTime? dataEntrada;
  final DateTime? dataSaida;
  final StatusOcupacaoAnimal? status;

  OcupacaoAnimalModel({
    this.id,
    this.ocupacao,
    this.animal,
    this.dataEntrada,
    this.dataSaida,
    this.status,
  });

   factory OcupacaoAnimalModel.fromJson(Map<String, dynamic> json) {
    return OcupacaoAnimalModel(
      id: json['id'],
      ocupacao: json['ocupacao'] != null ? OcupacaoModel.fromJson(json['ocupacao']) : null,
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
      dataEntrada: json['data_entrada'] != null ? DateTime.parse(json['data_entrada']) : null,
      dataSaida: json['data_saida'] != null ? DateTime.parse(json['data_saida']) : null,
      status: intToStatusOcupacaoAnimal[json['status']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ocupacao_id': ocupacao?.id,
      'animal_id': animal?.id,
      'data_entrada': dataEntrada?.toIso8601String(),
      'data_saida': dataSaida?.toIso8601String(),
      'status': statusOcupacaoToInt[status],
    };
  }

  @override
  String toString() {
    return 'id: $id, ocupacao: $ocupacao, animal: $animal, dataEntrada: $dataEntrada, dataSaida: $dataSaida, status: ${statusOcupacaoAnimalDescriptions[status]}';
  }
}
