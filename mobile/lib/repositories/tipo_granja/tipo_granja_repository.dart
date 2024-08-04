import 'package:syspig/model/tipo_granja_model.dart';

abstract class TipoGranjaRepository {

  Future<List<TipoGranjaModel>> getList();
}