
import 'package:flutter/material.dart';
import 'package:mobile/controller/granja/granja_controller.dart';
import 'package:mobile/repositories/granja/granja_repository_imp.dart';
import 'package:mobile/utils/dialogs.dart';


class CadastrarGranjaontroller with ChangeNotifier {

  final GranjaController _granjaController = GranjaController(GranjaRepositoryImp());

  String? _descricao;
  setDescricao(String value) => _descricao = value;

  String? _tipoGranja;
  setTipoGranja(String value) => _tipoGranja = value;

  String? descricaoError;
  String? tipoGranjaError;

  // Função para validar os campos
  bool validateFields() {
    bool isValid = true;
    const textObrigatorio = 'Campo obrigatório';

    // Validar e definir mensagens de erro para cada campo
    if (_descricao == null || _descricao!.isEmpty) {
      descricaoError = textObrigatorio;
      isValid = false;
    } else {
      descricaoError = '';
    }

    if (_tipoGranja == null || _tipoGranja!.isEmpty) {
      tipoGranjaError = textObrigatorio;
      isValid = false;
    } else {
      tipoGranjaError = '';
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