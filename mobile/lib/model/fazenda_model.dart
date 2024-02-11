class FazendaModel {
  final int id;
  final String nome;

  FazendaModel({
    required this.id,
    required this.nome,
  });

  factory FazendaModel.fromJson(Map<String, dynamic> json) {
    return FazendaModel(
      id: json['id'],
      nome: json['nome'],
    );
  }

  @override
  String toString() {
    return 'id: $id, nome: $nome';
  }
}
