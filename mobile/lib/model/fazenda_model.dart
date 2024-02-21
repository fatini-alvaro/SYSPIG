import 'package:mobile/model/cidade_model.dart';

class FazendaModel {
  final int id;
  final String nome;
  final CidadeModel cidade;

  FazendaModel({
    required this.id,
    required this.nome,
    required this.cidade,
  });

  factory FazendaModel.fromJson(Map<String, dynamic> json) {
    return FazendaModel(
      id: json['id'],
      nome: json['nome'],
      cidade: CidadeModel.fromJson(json['cidade']),
    );
  }

  @override
  String toString() {
    return 'id: $id, nome: $nome, cidade: $cidade';
  }
}
