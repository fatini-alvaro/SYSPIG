import 'package:mobile/model/baia_model.dart';

abstract class BaiaRepository {

  Future<List<BaiaModel>> getList();
}