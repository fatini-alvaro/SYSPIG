import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syspig/model/anotacao_model.dart';
import 'package:syspig/repositories/anotacao/anotacao_repository.dart';

class AnotacaoController {
  final AnotacaoRepository _anotacaoRepository;
  AnotacaoController(this._anotacaoRepository);

  ValueNotifier<List<AnotacaoModel>> anotacoes = ValueNotifier<List<AnotacaoModel>>([]);

  fetch(int fazendaId) async {
    anotacoes.value = await _anotacaoRepository.getList(fazendaId);
  }

  Future<AnotacaoModel> fetchAnotacaoById(int anotacaoId) async {
    
    AnotacaoModel anotacao = await  _anotacaoRepository.getById(anotacaoId);

    return anotacao;
  }

  getAnotacoesByBaia(int baiaId) async {
    anotacoes.value = await _anotacaoRepository.getAnotacoesByBaia(baiaId);
  }

  Future<AnotacaoModel> create(AnotacaoModel anotacaoNova) async {

    AnotacaoModel novaAnotacao = await  _anotacaoRepository.create(anotacaoNova);

    return novaAnotacao;
  }

  Future<AnotacaoModel> update(AnotacaoModel anotacaoEdicao) async {
    
    AnotacaoModel anotacaoEditado = await  _anotacaoRepository.update(anotacaoEdicao);

    return anotacaoEditado;
  }

  Future<bool> delete(int anotacaoExclusaoID) async {
    try {
      return await _anotacaoRepository.delete(anotacaoExclusaoID);
    } catch (e) {
      Logger().e('Erro ao excluir animal: $e');
      rethrow;
    }
  }
}