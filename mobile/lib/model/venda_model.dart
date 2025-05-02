import 'package:syspig/model/fazenda_model.dart';
import 'package:syspig/model/usuario_model.dart';

class VendaModel {
  final int? id;
  final FazendaModel? fazenda;
  final DateTime? datavenda;
  final int? quantidadeVendida;
  final double? valorVenda;
  final double? peso;
  final UsuarioModel? createdBy;
  final DateTime? createdAt;

  VendaModel({
    this.id,
    this.fazenda,
    this.datavenda,
    this.quantidadeVendida,
    this.valorVenda,
    this.peso,
    this.createdBy,
    this.createdAt,
  });

  factory VendaModel.fromJson(Map<String, dynamic> json) {
    return VendaModel(
      id: json['id'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      datavenda: json['data_venda'] != null ? DateTime.parse(json['data_venda']) : null,
      quantidadeVendida: json['quantidade_vendida'],
      valorVenda: json['valor_venda'] != null ? double.parse(json['valor_venda'].toString()) : null,
      peso: json['peso_venda'] != null ? double.parse(json['peso_venda'].toString()) : null,
      createdBy: json['createdBy'] != null ? UsuarioModel.fromJson(json['createdBy']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fazenda_id': fazenda?.id,
      'data_venda': datavenda?.toIso8601String(),
      'quantidade_vendida': quantidadeVendida,
      'valor_venda': valorVenda,
      'peso_venda': peso,
      'created_by': createdBy?.id,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, data_venda: $datavenda, quantidade_vendida: $quantidadeVendida, valor_venda: $valorVenda, created_by: $createdBy, created_at: $createdAt, peso_venda: $peso';
  }
}