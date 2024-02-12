class UfModel {
  final int id;
  final String sigla;
  final String nome;

  UfModel({
    required this.id,
    required this.sigla,
    required this.nome,
  });

  factory UfModel.fromJson(Map<String, dynamic> json) {
    return UfModel(
      id: json['id'],
      sigla: json['sigla'],
      nome: json['nome'],
    );
  }

  @override
  String toString() {
    return 'id: $id, sigla: $sigla, nome: $nome';
  }
}
