import 'package:flutter/material.dart';
import 'package:syspig/controller/animal/animal_controller.dart';
import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/animal_model.dart';
import 'package:syspig/repositories/animal/animal_repository_imp.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';
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

  AnimalModel? _animal;
  setAnimal(AnimalModel? value) => _animal = value;
  AnimalModel? get animal => _animal;

  Future<AnimalModel> createAnimal() async {
    return AnimalModel(
      numeroBrinco: _numeroBrinco!,
      sexo: _sexo!,
      dataNascimento: _dataNascimento,
      status: _status!,
    );
  }

  Future<bool> create(BuildContext context) async {
    final animalCriado = await AsyncHandler.execute(
      context: context,
      action: () async {
        final novoAnimal = await createAnimal();
        return await _animalController.create(novoAnimal);
      },
      loadingMessage: 'Aguarde, Criando Animal',
      successMessage: 'Animal criado com sucesso!',
    );

    return animalCriado != null;
  }

  Future<bool> update(BuildContext context, int animalId) async {
    final animalEditado = await AsyncHandler.execute(
      context: context,
      action: () async {
        final animalEditadoData = AnimalModel(
          id: animalId,
          numeroBrinco: _numeroBrinco!,
          sexo: _sexo!,
          dataNascimento: _dataNascimento,
          status: _status!,
        );
        return await _animalController.update(animalEditadoData);
      },
      loadingMessage: 'Aguarde, Editando Animal',
      successMessage: 'Animal editado com sucesso!',
    );

    return animalEditado != null;
  }

  Future<AnimalModel?> fetchAnimalById(int animalId) async {
    return await AsyncFetcher.fetch(
      action: () => _animalController.fetchAnimalById(animalId),
    );
  }
}
