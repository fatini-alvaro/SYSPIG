import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/model/tipo_usuario.dart';
import 'package:mobile/model/usuario_model.dart';

class UsuarioFazendaModel {
  final int id;
  final TipoUsuarioModel tipoUsuario;
  final UsuarioModel usuario;
  final FazendaModel fazenda; 

  UsuarioFazendaModel({
    required this.id,
    required this.tipoUsuario,
    required this.usuario,
    required this.fazenda,
  });

  factory UsuarioFazendaModel.fromJson(Map<String, dynamic> json) {
    return UsuarioFazendaModel(
      id: json['id'],
      tipoUsuario: json['tipo_usuario_id'],
      usuario: json['usuario_id'],
      fazenda: json['fazenda_id'],
    );
  }

  @override
  String toString() {
    return 'id: $id, tipo_usuario_id: $tipoUsuario, usuario_id: $usuario, fazenda_id: $fazenda';
  }
}
