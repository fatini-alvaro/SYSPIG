import 'package:mobile/model/granja_model.dart';

abstract class GranjaRepository {

  Future<List<GranjaModel>> getList();
}