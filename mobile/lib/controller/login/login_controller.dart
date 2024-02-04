import 'package:flutter/material.dart';
import 'package:mobile/utils/dialogs.dart';

class LoginController {
  
  String? _email;
  setEmail(String value) => _email = value; 

  String? _senha;
  setSenha(String value) => _senha = value; 

  Future<bool> auth(BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, validando credenciais');

    await Future.delayed(Duration(seconds: 2));

    Dialogs.hideLoading(context);

    return _email == 'teste@' && _senha == '1';
  }
  
}