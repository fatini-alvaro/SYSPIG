import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/model/tipo_granja_model.dart';

class GranjaModel {
  final int? id;
  final String descricao;
  final int? codigo;
  final FazendaModel? fazenda;
  final TipoGranjaModel tipoGranja;


  GranjaModel({
    this.id,
    required this.descricao,
    this.codigo,
    this.fazenda,
    required this.tipoGranja,
  });

  factory GranjaModel.fromJson(Map<String, dynamic> json) {
    return GranjaModel(
      id: json['id'],
      descricao: json['descricao'],
      codigo: json['codigo'],
      fazenda: FazendaModel.fromJson(json['fazenda']),
      tipoGranja: TipoGranjaModel.fromJson(json['tipoGranja']),
    );
  }

  @override
  String toString() {
    return 'id: $id, descricao: $descricao, codigo: $codigo, fazenda: $fazenda, tipoGranja: $tipoGranja';
  }
}
