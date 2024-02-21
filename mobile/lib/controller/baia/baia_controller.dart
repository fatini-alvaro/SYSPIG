import 'package:flutter/material.dart';
import 'package:mobile/model/baia_model.dart';
import 'package:mobile/repositories/baia/baia_repository.dart';

class BaiaController {
  final BaiaRepository _baiaRepository;
  BaiaController(this._baiaRepository);

  ValueNotifier<List<BaiaModel>> baias = ValueNotifier<List<BaiaModel>>([]);

  fetch() async {
    baias.value = await _baiaRepository.getList();
  }

  Future<bool> create (BuildContext context) async {

    return true;
  }
}