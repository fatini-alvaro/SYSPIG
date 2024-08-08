
import 'package:flutter/material.dart';
import 'package:syspig/controller/animal/animal_controller.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/utils/dialogs.dart';


class CadastrarAnimalController with ChangeNotifier {

  final AnimalController _animalController = AnimalController(AnimalRepositoryImp());

  String? _numeroBrinco;
  setNumeroBrinco(String? value) => _numeroBrinco = value;
  String? get numeroBrinco => _numeroBrinco;

  String? _sexo;
  setSexo(String? value) => _sexo = value;
  String? get sexo => _sexo;

  String? _status;
  setStatus(String? value) => _status = value;
  String? get status => _status;

  DateTime? _dataNascimento;
  setNascimento(DateTime? value) => _dataNascimento = value;
  DateTime? get dataNascimento => _dataNascimento;

  Future<bool> create(BuildContext context) async {

    Dialogs.showLoading(context, message:'Aguarde, Criando Animal');

    try {
      AnimalModel novoAnimal = await AnimalModel(
        numeroBrinco: _numeroBrinco!,
        sexo: _sexo!,
        dataNascimento: _dataNascimento,
        status:_status! 
      );

      AnimalModel animalCriada = await _animalController.create(context, novoAnimal);

      Dialogs.hideLoading(context);

      if (animalCriada != null) {
        Dialogs.successToast(context, 'Animal criado com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao criar Animal');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao criar Animal');
    }

    return true;
  }

  Future<bool> update(BuildContext context, AnimalModel animal) async {

    Dialogs.showLoading(context, message:'Aguarde, Editando Animal');

    try {
      AnimalModel animalEditadoData = await AnimalModel(
        id: animal.id,
        numeroBrinco: _numeroBrinco!,
        sexo: _sexo!,
        dataNascimento: _dataNascimento,
        status:_status! 
      );

      AnimalModel animalEditado = await _animalController.update(context, animalEditadoData);

      Dialogs.hideLoading(context);

      if (animalEditado != null) {
        Dialogs.successToast(context, 'Animal editada com sucesso!');
      } else {
        Dialogs.errorToast(context, 'Falha ao editada a Animal');
      }
    } catch (e) {
      print(e);
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Falha ao editar a Animal');
    }

    return true;
  }
}