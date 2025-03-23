import 'package:syspig/model/tipo_usuario.dart';

class UsuarioModel {
  final int? id;
  final String nome;
  final String email;
  final TipoUsuarioModel? tipoUsuario;
  String? senha;
  String? accessToken;
  String? refreshToken;

  UsuarioModel({
    this.id,
    required this.nome,
    required this.email,
    this.tipoUsuario,
    this.senha,
    this.accessToken,
    this.refreshToken,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      tipoUsuario: json['tipoUsuario'] != null ? TipoUsuarioModel.fromJson(json['tipoUsuario']) : null,
      senha: json['senha'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  @override
  String toString() {
    return 'id: $id, nome: $nome, email: $email, tipoUsuario: $tipoUsuario, senha: $senha, accessToken: $accessToken, refreshToken: $refreshToken';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipo_usuario_id': tipoUsuario?.id,
      'senha': senha,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

}