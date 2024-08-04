import 'package:flutter/material.dart';
import 'package:syspig/model/usuario_model.dart';
import 'package:syspig/repositories/usuario/usuario_repository.dart';

class UsuarioController {
  final UsuarioRepository _usuarioRepository;
  UsuarioController(this._usuarioRepository);

  Future<UsuarioModel> create(BuildContext context, UsuarioModel usuarioNova) async {
    
    UsuarioModel novoUsuario = await  _usuarioRepository.create(usuarioNova);

    return novoUsuario;
  }
  
}