class TipoGranjaModel {
  final int id;
  final String descricao;


  TipoGranjaModel({
    required this.id,
    required this.descricao,
  });

  factory TipoGranjaModel.fromJson(Map<String, dynamic> json) {
    return TipoGranjaModel(
      id: json['id'],
      descricao: json['descricao'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TipoGranjaModel && other.id == id && other.descricao == descricao;
  }

  @override
  int get hashCode => id.hashCode ^ descricao.hashCode;

  @override
  String toString() {
    return 'id: $id, descricao: $descricao';
  }
}
