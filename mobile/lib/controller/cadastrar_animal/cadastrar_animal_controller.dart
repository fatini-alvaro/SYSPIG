
import 'package:flutter/material.dart';
import 'package:mobile/controller/animal/animal_controller.dart';
import 'package:mobile/repositories/animal/animal_repository_imp.dart';
import 'package:mobile/utils/dialogs.dart';


class CadastrarAnimalController with ChangeNotifier {

  final AnimalController _animalController = AnimalController(AnimalRepositoryImp());

  String? _numeroBrinco;
  setNumeroBrinco(String value) => _numeroBrinco = value;

  String? _fazenda;
  setFazenda(String value) => _fazenda = value;

  String? _sexo;
  setSexo(String value) => _sexo = value;

  String? _status;
  setStatus(String value) => _status = value;

  String? _dataNascimento;
  setNascimento(String value) => _dataNascimento = value;

  String? numeroError;
  String? sexoError;
  String? statusError;
  String? dataNascimentoError;

  // Função para validar os campos
  bool validateFields() {
    bool isValid = true;
    const textObrigatorio = 'Campo obrigatório';

    // Validar e definir mensagens de erro para cada campo
    if (_numeroBrinco == null || _numeroBrinco!.isEmpty) {
      numeroError = textObrigatorio;
      isValid = false;
    } else {
      numeroError = '';
    }

    if (_sexo == null || _sexo!.isEmpty) {
      sexoError = textObrigatorio;
      isValid = false;
    } else {
      sexoError = '';
    }

    if (_status == null || _status!.isEmpty) {
      statusError = textObrigatorio;
      isValid = false;
    } else {
      statusError = '';
    }

    if (_dataNascimento == null || _dataNascimento!.isEmpty) {
      dataNascimentoError = textObrigatorio;
      isValid = false;
    } else {
      dataNascimentoError = '';
    }
    
    
    notifyListeners();

    return isValid;
  }

  Future<bool> create(BuildContext context) async {

    if (!validateFields()) {
      // Se houver campos vazios, retornar false sem realizar a ação
      return false;
    }

    Dialogs.showLoading(context, message:'Aguarde, Criando Novo Animal');
    await Future.delayed(Duration(seconds: 2));
    //To-do chama o create do fazendacontroller

    Dialogs.hideLoading(context);

    return true;
  }
}