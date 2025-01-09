import 'package:flutter/material.dart';
import 'package:syspig/controller/animal/animal_controller.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/utils/dialogs.dart';

class CadastrarAnimalController with ChangeNotifier {
  final AnimalController _animalController =
      AnimalController(AnimalRepositoryImp());

  String? _numeroBrinco;
  setNumeroBrinco(String? value) => _numeroBrinco = value;
  String? get numeroBrinco => _numeroBrinco;

  SexoAnimal? _sexo;
  setSexo(SexoAnimal? value) => _sexo = value;
  SexoAnimal? get sexo => _sexo;

  StatusAnimal? _status;
  setStatus(StatusAnimal? value) => _status = value;
  StatusAnimal? get status => _status;

  DateTime? _dataNascimento;
  setNascimento(DateTime? value) => _dataNascimento = value;
  DateTime? get dataNascimento => _dataNascimento;

  Future<AnimalModel> createAnimal() async {
    return AnimalModel(
      numeroBrinco: _numeroBrinco!,
      sexo: _sexo!,
      dataNascimento: _dataNascimento,
      status: _status!,
    );
  }

  Future<bool> create(BuildContext context) async {
    Dialogs.showLoading(context, message: 'Aguarde, Criando Animal');

    try {
      final novoAnimal = await createAnimal();
      final animalCriado = await _animalController.create(novoAnimal);

      Dialogs.hideLoading(context);
      if (animalCriado != null) {
        Dialogs.successToast(context, 'Animal criado com sucesso!');
        return true;
      } else {
        Dialogs.errorToast(context, 'Falha ao criar Animal');
      }
    } catch (e) {
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Erro: $e');
    }
    return false;
  }

  Future<bool> update(BuildContext context, int animalId) async {
    Dialogs.showLoading(context, message: 'Aguarde, Editando Animal');

    try {
      final animalEditadoData = AnimalModel(
        id: animalId,
        numeroBrinco: _numeroBrinco!,
        sexo: _sexo!,
        dataNascimento: _dataNascimento,
        status: _status!,
      );

      final animalEditado = await _animalController.update(animalEditadoData);

      Dialogs.hideLoading(context);
      if (animalEditado != null) {
        Dialogs.successToast(context, 'Animal editado com sucesso!');
        return true;
      } else {
        Dialogs.errorToast(context, 'Falha ao editar Animal');
      }
    } catch (e) {
      Dialogs.hideLoading(context);
      Dialogs.errorToast(context, 'Erro: $e');
    }
    return false;
  }

  Future<AnimalModel?> fetchAnimalById(int animalId) async {
    try {
      return await _animalController.fetchAnimalById(animalId);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
