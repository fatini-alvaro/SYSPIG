import 'package:mobile/model/ocupacao_model.dart';

abstract class OcupacaoRepository {

  Future<OcupacaoModel> create(OcupacaoModel ocupacao);
}