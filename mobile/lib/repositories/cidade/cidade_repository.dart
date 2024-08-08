import 'package:syspig/model/cidade_model.dart';

abstract class CidadeRepository {

  Future<List<CidadeModel>> getList();
}