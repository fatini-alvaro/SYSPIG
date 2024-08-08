
import 'package:syspig/model/inseminacao_model.dart';

abstract class InseminacaoRepository {

  Future<List<InseminacaoModel>> getList();
}