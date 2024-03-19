import 'package:mobile/model/fazenda_model.dart';

abstract class FazendaRepository {

  Future<List<FazendaModel>> getList(int userId);
}