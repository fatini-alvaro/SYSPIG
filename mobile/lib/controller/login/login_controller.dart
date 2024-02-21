import 'package:flutter/material.dart';
import 'package:mobile/services/prefs_service.dart';
import 'package:mobile/utils/dialogs.dart';

class LoginController {
  
  String? _email;
  setEmail(String value) => _email = value; 

  String? _senha;
  setSenha(String value) => _senha = value; 

  Future<bool> auth(BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, validando credenciais');

    await Future.delayed(Duration(seconds: 1));

    Dialogs.hideLoading(context);

    if(_email == 't') {
      PrefsService.save(_email!);
      return true;
    } return false;
  }

  Future<bool> autenticarUsuario() async {
      // Lógica de autenticação aqui
      // Por exemplo, fazer uma requisição para o servidor
      // Verificar se o usuário e senha são válidos
      // Retorna true se a autenticação for bem-sucedida, false caso contrário
      try {
        // Implemente aqui a lógica de autenticação
        // Por exemplo, fazer uma requisição HTTP para um servidor
        // Se a autenticação for bem-sucedida, retorne true
        if (_email == 't@gmail.com' && _senha == '123456') {
          PrefsService.save(_email!);
          return true;
        }
        return false;
      } catch (e) {
        // Em caso de erro, imprima o erro e retorne false
        print('Erro na autenticação: $e');
        return false;
      }
    }
}