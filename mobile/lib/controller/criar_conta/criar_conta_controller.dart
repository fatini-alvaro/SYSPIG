
import 'package:dio/dio.dart';
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
  
  Future<bool> create(BuildContext context) async {
    bool sucesso = false;
    Dialogs.showLoading(context, message:'Aguarde, Criando Nova Conta');
    
    try {
      UsuarioModel novoUsuario = UsuarioModel(
        email: _email,
        nome: _nome!,
        senha: _senha! 
      );

      UsuarioModel? usuarioCriado = await _usuarioController.create(context, novoUsuario);

      if (usuarioCriado != null) {
        sucesso = true;
        Dialogs.successToast(context, 'Usuário criado com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao criar usuário');
      }
    } catch (e) {
      if (context.mounted) {
        // Tratar o erro de forma mais limpa
        String mensagemErro = 'Falha ao criar usuário: ';
        
        if (e is DioException && e.response != null) {
          mensagemErro += e.response?.data['message'] ?? 'Erro desconhecido';
        } else if (e is Exception) {
          mensagemErro += e.toString().replaceFirst('Exception:', '').trim();
        } else if (e is String) {
          mensagemErro += e;
        } else {
          mensagemErro += 'Erro desconhecido';
        }
        
        Dialogs.errorToast(context, mensagemErro);
      }
    } finally {
      if (context.mounted) {
        Dialogs.hideLoading(context);
      }
    }

    return sucesso;
  }
}