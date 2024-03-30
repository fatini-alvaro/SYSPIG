import 'package:mobile/model/baia_model.dart';

abstract class BaiaRepository {

  Future<List<BaiaModel>> getList(int granjaId);

  Future<BaiaModel> create(BaiaModel baia);

  Future<BaiaModel> update(BaiaModel baia);

  Future<bool> delete(int baiaId);
}