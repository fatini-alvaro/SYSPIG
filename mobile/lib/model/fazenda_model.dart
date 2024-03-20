import 'package:mobile/model/cidade_model.dart';

class FazendaModel {
  final int? id;
  final String nome;
  final CidadeModel? cidade;

  FazendaModel({
    this.id,
    required this.nome,
    this.cidade,
  });

  factory FazendaModel.fromJson(Map<String, dynamic> json) {
    return FazendaModel(
      id: json['id'],
      nome: json['nome'],
      cidade: json['cidade'] != null ? CidadeModel.fromJson(json['cidade']) : null,
    );
  }
  
  @override
  String toString() {
    return 'id: $id, nome: $nome, cidade: $cidade';
  }
}
