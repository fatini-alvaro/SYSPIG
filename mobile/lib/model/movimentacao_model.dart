import 'package:syspig/enums/movimentacao_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/baia_model.dart';
import 'package:syspig/model/usuario_model.dart';

class MovimentacaoModel {
  final int? id;
  final DateTime? dataMovimentacao;
  final TipoMovimentacao? tipo;
  final StatusMovimentacao? status;
  final BaiaModel? baiaOrigem;
  final BaiaModel? baiaDestino;
  final AnimalModel? animal;
  final UsuarioModel? usuario;
  final String? observacoes;

  MovimentacaoModel({
    this.id,
    this.dataMovimentacao,
    this.tipo,
    this.baiaOrigem,
    this.baiaDestino,
    this.animal,
    this.usuario,
    this.observacoes,
    this.status,
  });

  factory MovimentacaoModel.fromJson(Map<String, dynamic> json) {
    return MovimentacaoModel(
      id: json['id'],
      dataMovimentacao: json['dataMovimentacao'] != null ? DateTime.parse(json['dataMovimentacao']) : null,
      tipo: intToTipoMovimentacao[json['tipo']],
      status: intToStatusMovimentacao[json['status']],
      baiaOrigem: json['baiaOrigem'] != null ? BaiaModel.fromJson(json['baiaOrigem']) : null,
      baiaDestino: json['baiaDestino'] != null ? BaiaModel.fromJson(json['baiaDestino']) : null,
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
      usuario: json['usuario'] != null ? UsuarioModel.fromJson(json['usuario']) : null,
      observacoes: json['observacoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data_movimentacao': dataMovimentacao?.toIso8601String(),
      'tipo': tipoMovimentacaoToInt[tipo],
      'baia_origem_id': baiaOrigem?.id,
      'baia_destino_id': baiaDestino?.id,
      'animal_id': animal?.id,
      'usuario_id': usuario?.id,
      'observacoes': observacoes,
    };
  }

  @override
  String toString() {
    return 'id: $id, dataMovimentacao: $dataMovimentacao, tipo: ${tipoMovimentacaoDescriptions[tipo]}, status: ${statusMovimentacaoDescriptions[status]}, baiaOrigem: $baiaOrigem, baiaDestino: $baiaDestino, animal: $animal, usuario: $usuario, observacoes: $observacoes';
  }
}