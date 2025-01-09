import 'package:flutter/material.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository.dart';

class OcupacaoController {
  final OcupacaoRepository _ocupacaoRepository;
  OcupacaoController(this._ocupacaoRepository);

  Future<OcupacaoModel> fetchOcupacaoById(int ocupacaoId) async {
    
    OcupacaoModel ocupacao = await  _ocupacaoRepository.getById(ocupacaoId);

    return ocupacao;
  }
  
}