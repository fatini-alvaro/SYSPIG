
import 'package:flutter/material.dart';
import 'package:mobile/controller/anotacao/anotacao_controller.dart';
import 'package:mobile/repositories/anotacao/anotacao_repository_imp.dart';
import 'package:mobile/utils/dialogs.dart';


class CadastrarAnotacaoController with ChangeNotifier {

  final AnotacaoController _anotacaoController = AnotacaoController(AnotacaoRepositoryImp());

  String? _baia;
  setBaia(String value) => _baia = value;

  String? _Animal;
  setAnimal(String value) => _Animal = value;

  String? _Descricao;
  setDescricao(String value) => _Descricao = value;

  String? descricaoError;

  // Função para validar os campos
  bool validateFields() {
    bool isValid = true;
    const textObrigatorio = 'Campo obrigatório';

    // Validar e definir mensagens de erro para cada campo
    if (_Descricao == null || _Descricao!.isEmpty) {
      descricaoError = textObrigatorio;
      isValid = false;
    } else {
      descricaoError = '';
    }
    
    notifyListeners();

    return isValid;
  }

  Future<bool> create(BuildContext context) async {

    if (!validateFields()) {
      // Se houver campos vazios, retornar false sem realizar a ação
      return false;
    }

    Dialogs.showLoading(context, message:'Aguarde, Criando Nova anotação');
    await Future.delayed(Duration(seconds: 2));
    //To-do chama o create do fazendacontroller

    Dialogs.hideLoading(context);

    return true;
  }
}