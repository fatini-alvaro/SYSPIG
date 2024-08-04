
import 'package:flutter/material.dart';
import 'package:syspig/controller/usuario/usuario_controller.dart';
import 'package:syspig/model/usuario_model.dart';
import 'package:syspig/repositories/usuario/usuario_repository_imp.dart';
import 'package:syspig/utils/dialogs.dart';


class CriarContaController with ChangeNotifier {

  final UsuarioController _usuarioController = UsuarioController(UsuarioRepositoryImp());

  String _email = '';
  setEmail(String value) => _email = value;

  String? _nome;
  setNome(String value) => _nome = value;

  String? _senha;
  setSenha(String value) => _senha = value; 
  
  Future<bool> create (BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Nova Conta');
    
    try {
      UsuarioModel novoUsuario = await UsuarioModel(
        email: _email,
        nome: _nome!,
        senha: _senha! 
      );

      UsuarioModel usuarioCriado = await _usuarioController.create(context, novoUsuario);

      Dialogs.hideLoading(context);

      if (usuarioCriado != null) {
        Dialogs.successToast(context, 'Usuário criado com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao criar usuário');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao criar usuário');
    }
    
    Dialogs.hideLoading(context);    

    return true;
  }
}