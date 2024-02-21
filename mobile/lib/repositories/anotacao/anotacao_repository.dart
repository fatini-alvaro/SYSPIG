import 'package:mobile/model/anotacao_model.dart';

abstract class AnotacaoRepository {

  Future<List<AnotacaoModel>> getList();
}