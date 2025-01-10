import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syspig/repositories/usuario/usuario_repository.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/dialogs.dart';

class LoginController {

  final UsuarioRepository _usuarioRepository;
  LoginController(this._usuarioRepository);
  
  String? _email;
  setEmail(String value) => _email = value; 

  String? _senha;
  setSenha(String value) => _senha = value; 

  Future<bool> autenticarUsuario(BuildContext context) async {    
    bool sucesso = false;
    Dialogs.showLoading(context, message:'Aguarde, autenticando usuário');
  
    try {
      
      var usuarioComToken = await _usuarioRepository.auth(_email!, _senha!);
 
      PrefsService.save(usuarioComToken);

      return true;      
    } catch (e) {
      if (context.mounted) {
        // Tratar o erro de forma mais limpa
        String mensagemErro = 'Falha ao autenticar usuário: ';
        
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