import 'package:syspig/model/ocupacao_model.dart';

abstract class OcupacaoRepository {

  Future<OcupacaoModel> create(OcupacaoModel ocupacao);

  Future<OcupacaoModel> getById(int ocupacaoId);
}