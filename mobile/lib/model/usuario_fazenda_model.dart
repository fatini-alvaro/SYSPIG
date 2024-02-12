class UsuarioFazendaModel {
  final int id;
  final int tipoUsuarioId;
  final int usuarioId;
  final int fazendaId; 

  UsuarioFazendaModel({
    required this.id,
    required this.tipoUsuarioId,
    required this.usuarioId,
    required this.fazendaId,
  });

  factory UsuarioFazendaModel.fromJson(Map<String, dynamic> json) {
    return UsuarioFazendaModel(
      id: json['id'],
      tipoUsuarioId: json['tipo_usuario_id'],
      usuarioId: json['usuario_id'],
      fazendaId: json['fazenda_id'],
    );
  }

  @override
  String toString() {
    return 'id: $id, tipo_usuario_id: $tipoUsuarioId, usuario_id: $usuarioId, fazenda_id: $fazendaId';
  }
}
