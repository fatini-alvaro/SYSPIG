class UfModel {
  final int? id;
  final String? sigla;
  final String? nome;

  UfModel({
    this.id,
    this.sigla,
    this.nome,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sigla': sigla,
      'nome': nome,
    };
  }
}
