import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/lote_animal_model.dart';

class LoteModel {
  final int? id;
  final FazendaModel? fazenda;
  final String? numeroLote;
  final String? descricao;
  final DateTime? data;
  final DateTime? dataInicio;
  final List<LoteAnimalModel>? loteAnimais;

  LoteModel({
    this.id,
    this.fazenda,
    this.numeroLote,
    this.descricao,
    this.data,
    this.dataInicio,
    this.loteAnimais
  });

  factory LoteModel.fromJson(Map<String, dynamic> json) {
    return LoteModel(
      id: json['id'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      numeroLote: json['numero_lote'],
      descricao: json['descricao'],
      dataInicio: json['data_inicio'] != null ? DateTime.parse(json['data_inicio']) : null,
      data: json['data'] != null ? DateTime.parse(json['data']) : null,
      loteAnimais: (json['loteAnimais'] as List?)?.map((item) => LoteAnimalModel.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fazenda_id': fazenda?.id,
      'numero_lote': numeroLote,
      'descricao': descricao,
      'data': data?.toIso8601String(),
      'data_inicio': dataInicio?.toIso8601String(),
      'lote_animais': loteAnimais?.map((loteAnimal) => loteAnimal.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, numero: $numeroLote, descricao: $descricao, data: $data, loteAnimais: $loteAnimais, dataInicio: $dataInicio';
  }
}
