
import 'package:flutter/material.dart';
import 'package:mobile/controller/fazenda/fazenda_controller.dart';
import 'package:mobile/repositories/fazenda/fazenda_repository_imp.dart';
import 'package:mobile/utils/dialogs.dart';


class CadastrarFazendaController with ChangeNotifier {

  final FazendaController _fazendaController = FazendaController(FazendaRepositoryImp());

  String? _nome;
  setNome(String value) => _nome = value;

  String? _cidade;
  setCidade(String value) => _cidade = value;

  String? nomeError;
  String? cidadeError;

  // Função para validar os campos
  bool validateFields() {
    bool isValid = true;
    const textObrigatorio = 'Campo obrigatório';

    // Validar e definir mensagens de erro para cada campo
    if (_nome == null || _nome!.isEmpty) {
      nomeError = textObrigatorio;
      isValid = false;
    } else {
      nomeError = '';
    }

    if (_cidade == null || _cidade!.isEmpty) {
      cidadeError = textObrigatorio;
      isValid = false;
    } else {
      cidadeError = '';
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
    //To-do chama o create do fazendacontroller

    Dialogs.hideLoading(context);

    return true;
  }
}