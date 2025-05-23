import 'package:syspig/model/granja_model.dart';

abstract class GranjaRepository {

  Future<List<GranjaModel>> getList(int fazendaId);

  Future<GranjaModel> create(GranjaModel granja);

  Future<GranjaModel> update(GranjaModel granja);

  Future<bool> delete(int granjaId);

  Future<GranjaModel> getById(int granjaId);
}