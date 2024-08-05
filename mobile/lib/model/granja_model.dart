import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/tipo_granja_model.dart';

class GranjaModel {
  final int? id;
  final String descricao;
  final int? codigo;
  final FazendaModel? fazenda;
  final TipoGranjaModel? tipoGranja;


  GranjaModel({
    this.id,
    required this.descricao,
    this.codigo,
    this.fazenda,
    this.tipoGranja,
  });

  factory GranjaModel.fromJson(Map<String, dynamic> json) {
    return GranjaModel(
      id: json['id'],
      descricao: json['descricao'],
      codigo: json['codigo'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      tipoGranja: json['tipoGranja'] != null ? TipoGranjaModel.fromJson(json['tipoGranja']) : null,
    );
  }

  @override
  String toString() {
    return 'id: $id, descricao: $descricao, codigo: $codigo, fazenda: $fazenda, tipoGranja: $tipoGranja';
  }
}
