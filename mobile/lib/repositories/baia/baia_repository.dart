import 'package:syspig/model/baia_model.dart';

abstract class BaiaRepository {

  Future<List<BaiaModel>> getList(int granjaId);

  Future<List<BaiaModel>> getListAll(int fazendaId);

  Future<BaiaModel> create(BaiaModel baia);

  Future<BaiaModel> update(BaiaModel baia);

  Future<bool> delete(int baiaId);
}