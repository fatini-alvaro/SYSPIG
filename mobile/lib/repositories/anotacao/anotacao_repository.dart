import 'package:syspig/model/anotacao_model.dart';

abstract class AnotacaoRepository {

  Future<List<AnotacaoModel>> getList(int fazendaId);

  Future<AnotacaoModel> getById(int anotacaoId);

  Future<AnotacaoModel> create(AnotacaoModel anotacao);

  Future<AnotacaoModel> update(AnotacaoModel anotacao);

  Future<bool> delete(int baiaId);

  Future<List<AnotacaoModel>> getAnotacoesByBaia(int baiaId);
}