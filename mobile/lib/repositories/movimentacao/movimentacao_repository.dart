import 'package:syspig/model/movimentacao_model.dart';

abstract class MovimentacaoRepository {

  Future<List<MovimentacaoModel>> getList(int fazendaId);
}