import 'package:flutter/material.dart';
import 'package:mobile/controller/movimentacao/movimentacao_controller.dart';
import 'package:mobile/repositories/movimentacao/movimentacao_repository_imp.dart';
import 'package:mobile/utils/dialogs.dart';

class CadastrarMovimentacaoController with ChangeNotifier {
  final MovimentacaoController _movimentacaoController = MovimentacaoController(MovimentacaoRepositoryImp());

  String? _descricao;
  setGranja(String value) => _descricao = value;

  String? _baia;
  setBaia(String value) => _baia = value;

  String? granjaError;
  String? baiaError;

  // Função para validar os campos
  bool validateFields() {
    bool isValid = true;
    const textObrigatorio = 'Campo obrigatório';

    // Validar e definir mensagens de erro para cada campo
    if (_descricao == null || _descricao!.isEmpty) {
      granjaError = textObrigatorio;
      isValid = false;
    } else {
      granjaError = '';

    }

    if (_baia == null || _baia!.isEmpty) {
      baiaError = textObrigatorio;
      isValid = false;
    } else {
      baiaError = '';
    }

    notifyListeners();

    return isValid;
  }

  Future<bool> create(BuildContext context) async {
    if (!validateFields()) {
      // Se houver campos vazios, retornar false sem realizar a ação
      return false;
    }

    Dialogs.showLoading(context, message: 'Aguarde, registrando transferência.');
    await Future.delayed(Duration(seconds: 2));
    //To-do chama o create do fazendacontroller

    Dialogs.hideLoading(context);

    return true;
  }
}