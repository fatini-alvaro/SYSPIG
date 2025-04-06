import 'package:syspig/model/ocupacao_model.dart';

abstract class OcupacaoRepository {

  Future<OcupacaoModel> create(OcupacaoModel ocupacao);

  Future<OcupacaoModel> getById(int ocupacaoId);

  Future<OcupacaoModel?> getByBaiaId(int baiaId);

  Future<List<OcupacaoModel>> getList(int fazendaId);

  Future<Map<String, dynamic>> movimentarAnimais({
    required List<Map<String, int>> movimentacoes,
  });
}