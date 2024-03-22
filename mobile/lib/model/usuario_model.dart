import 'package:mobile/model/tipo_usuario.dart';

class UsuarioModel {
  final int? id;
  final String nome;
  final String email;
  final TipoUsuarioModel? tipoUsuario;
  final String senha;

  UsuarioModel({
    this.id,
    required this.nome,
    required this.email,
    this.tipoUsuario,
    required this.senha,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      tipoUsuario: json['tipoUsuario'] != null ? TipoUsuarioModel.fromJson(json['tipoUsuario']) : null,
      senha: json['senha'],
    );
  }

  @override
  String toString() {
    return 'id: $id, nome: $nome, email: $email, tipoUsuario: $tipoUsuario, senha: $senha';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipoUsuario': tipoUsuario != null ? tipoUsuario!.toJson() : null,
      'senha': senha
    };
  }

}