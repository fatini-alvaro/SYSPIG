import 'package:mobile/model/tipo_usuario.dart';

class UsuarioModel {
  final int id;
  final String nome;
  final String email;
  final TipoUsuarioModel tipoUsuario;
  final String senha;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipoUsuario,
    required this.senha,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      tipoUsuario: TipoUsuarioModel.fromJson(json['tipoUsuario']),
      senha: json['senha'],
    );
  }

  @override
  String toString() {
    return 'id: $id, nome: $nome, email: $email, tipoUsuario: $tipoUsuario';
  }
}