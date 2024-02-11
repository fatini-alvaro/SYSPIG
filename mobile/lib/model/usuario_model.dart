class UsuarioModel {
  final int id;
  final String nome;
  final String email;
  final int tipoUsuarioId;
  final String senha;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipoUsuarioId,
    required this.senha,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      tipoUsuarioId: json['tipo_usuario_id'],
      senha: json['senha'],
    );
  }

  @override
  String toString() {
    return 'id: $id, nome: $nome, email: $email, tipo_usuario_id: $tipoUsuarioId';
  }
}