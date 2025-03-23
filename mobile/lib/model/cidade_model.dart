import 'package:syspig/model/uf_model.dart';

class CidadeModel {
  final int id;
  final String nome;
  final UfModel? uf;

  CidadeModel({
    required this.id,
    required this.nome,
    this.uf,
  });

  factory CidadeModel.fromJson(Map<String, dynamic> json) {
    return CidadeModel(
      id: json['id'],
      nome: json['nome'],
      uf: json['uf'] != null ? UfModel.fromJson(json['uf']) : null,
    );
  }

  @override
  String toString() {
    return 'id: $id, nome: $nome, uf: $uf';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'uf_id': uf?.id,
    };
  }
}
