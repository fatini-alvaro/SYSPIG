class TipoUsuarioModel {
  final int id;
  final String descricao;

  TipoUsuarioModel({
    required this.id,
    required this.descricao,
  });

  factory TipoUsuarioModel.fromJson(Map<String, dynamic> json) {
    return TipoUsuarioModel(
      id: json['id'],
      descricao: json['descricao'],
    );
  }

  @override
  String toString() {
    return 'id: $id, descricao: $descricao';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }
}
