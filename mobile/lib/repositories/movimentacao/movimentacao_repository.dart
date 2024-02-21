import 'package:mobile/model/movimentacao_model.dart';

abstract class MovimentacaoRepository {

  Future<List<MovimentacaoModel>> getList();
}