import 'package:flutter/material.dart';
import 'package:syspig/controller/inseminacao/inseminacao_controller.dart';
import 'package:syspig/repositories/iseminacao/inseminacao_repository_imp.dart';
import 'package:syspig/utils/dialogs.dart';

class CadastrarInseminacaoController with ChangeNotifier {
  final InseminacaoController _inseminacaoController = InseminacaoController(InseminacaoRepositoryImp());

  String? _porco;
  setPorco(String value) => _porco = value;

  String? _porca;
  setPorca(String value) => _porca = value;

  String? _data;
  setData(String value) => _data = value;

  String? porcaError;

  // Função para validar os campos
  bool validateFields() {
    bool isValid = true;
    const textObrigatorio = 'Campo obrigatório';

    // Validar e definir mensagens de erro para cada campo
    if (_porca == null || _porca!.isEmpty) {
      porcaError = textObrigatorio;
      isValid = false;
    } else {
      porcaError = '';

    }

    notifyListeners();

    return isValid;
  }

  Future<bool> create(BuildContext context) async {
    if (!validateFields()) {
      // Se houver campos vazios, retornar false sem realizar a ação
      return false;
    }

    Dialogs.showLoading(context, message: 'Aguarde, registrando inseminação.');
    await Future.delayed(Duration(seconds: 2));
    //To-do chama o create do fazendacontroller

    Dialogs.hideLoading(context);

    return true;
  }
}