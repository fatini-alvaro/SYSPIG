
import 'package:flutter/material.dart';
import 'package:mobile/controller/baia/baia_controller.dart';
import 'package:mobile/repositories/baia/baia_repository_imp.dart';
import 'package:mobile/utils/dialogs.dart';


class CadastrarBaiaController with ChangeNotifier {

  final BaiaController _baiaController = BaiaController(BaiaRepositoryImp());

  String? _numero;
  setNumero(String value) => _numero = value;

  String? _granja;
  setGranja(String value) => _granja = value;

  String? _capacidade;
  setCapacidade(String value) => _capacidade = value;

  String? numeroError;
  String? granjaError;

  // Função para validar os campos
  bool validateFields() {
    bool isValid = true;
    const textObrigatorio = 'Campo obrigatório';

    // Validar e definir mensagens de erro para cada campo
    if (_numero == null || _numero!.isEmpty) {
      numeroError = textObrigatorio;
      isValid = false;
    } else {
      numeroError = '';
    }

    if (_granja == null || _granja!.isEmpty) {
      granjaError = textObrigatorio;
      isValid = false;
    } else {
      granjaError = '';
    }
    
    notifyListeners();

    return isValid;
  }

  Future<bool> create (BuildContext context) async {

    if (!validateFields()) {
      // Se houver campos vazios, retornar false sem realizar a ação
      return false;
    }

    Dialogs.showLoading(context, message:'Aguarde, Criando Nova Baia');
    await Future.delayed(Duration(seconds: 2));
    //To-do chama o create do fazendacontroller

    Dialogs.hideLoading(context);

    return true;
  }
}