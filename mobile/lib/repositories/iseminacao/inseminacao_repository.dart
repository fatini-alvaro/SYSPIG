
import 'package:syspig/model/inseminacao_model.dart';

abstract class InseminacaoRepository {

  Future<Map<String, dynamic>> inseminarAnimais({
    required List<InseminacaoModel>inseminacoes,
  });

  Future<List<InseminacaoModel>> getList();
}