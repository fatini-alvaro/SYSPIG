import 'package:flutter/material.dart';
import 'package:mobile/model/anotacao_model.dart';
import 'package:mobile/repositories/anotacao/anotacao_repository.dart';

class AnotacaoController {
  final AnotacaoRepository _anotacaoRepository;
  AnotacaoController(this._anotacaoRepository);

  ValueNotifier<List<AnotacaoModel>> anotacoes = ValueNotifier<List<AnotacaoModel>>([]);

  fetch(int fazendaId) async {
    anotacoes.value = await _anotacaoRepository.getList(fazendaId);
  }

  getAnotacoesByBaia(int baia_id) async {
    anotacoes.value = await _anotacaoRepository.getAnotacoesByBaia(baia_id);
  }

  Future<AnotacaoModel> create(BuildContext context, AnotacaoModel baiaNova) async {

    AnotacaoModel novaAnotacao = await  _anotacaoRepository.create(baiaNova);

    return novaAnotacao;
  }

  Future<AnotacaoModel> update(BuildContext context, AnotacaoModel anotacaoEdicao) async {
    
    AnotacaoModel anotacaoEditado = await  _anotacaoRepository.update(anotacaoEdicao);

    return anotacaoEditado;
  }

  Future<bool> delete(BuildContext context, int anotacaoExclusaoID) async {
    
    bool excluido = await  _anotacaoRepository.delete(anotacaoExclusaoID);

    return excluido;
  }
}