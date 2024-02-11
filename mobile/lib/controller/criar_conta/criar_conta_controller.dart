
import 'package:flutter/material.dart';
import 'package:mobile/controller/login/login_controller.dart';
import 'package:mobile/utils/dialogs.dart';


class CriarContaController with ChangeNotifier {

  final LoginController _loginController = LoginController();

  String? _email;
  setEmail(String value) => _email = value;

  String? _nome;
  setNome(String value) => _nome = value;

  String? _senha;
  setSenha(String value) => _senha = value;

  String? _telefone;
  setTelefone(String value) => _telefone = value;

  String? emailError;
  String? nomeError;
  String? senhaError;

  // Função para validar os campos
  bool validateFields() {
    bool isValid = true;

    // Validar e definir mensagens de erro para cada campo
    if (_email == null || _email!.isEmpty) {
      emailError = 'Campo obrigatório';
      isValid = false;
    } else {
      emailError = '';
    }

    if (_nome == null || _nome!.isEmpty) {
      nomeError = 'Campo obrigatório';
      isValid = false;
    } else {
      nomeError = '';
    }

    if (_senha == null || _senha!.isEmpty) {
      senhaError = 'Campo obrigatório';
      isValid = false;
    } else {
      senhaError = '';
    }

    notifyListeners();

    return isValid;
  }

  Future<bool> create (BuildContext context) async {

    if (!validateFields()) {
      // Se houver campos vazios, retornar false sem realizar a ação
      return false;
    }

    Dialogs.showLoading(context, message:'Aguarde, Criando Nova Conta');
    await Future.delayed(Duration(seconds: 2));
    //To-do Criar novo usuario na api

    Dialogs.hideLoading(context);
    //TO-DO Chama o auth passando as credenciais do novo usuario    

    return true;
  }
}