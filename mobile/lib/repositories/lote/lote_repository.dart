
import 'package:mobile/model/lote_model.dart';

abstract class LoteRepository {

  Future<List<LoteModel>> getList();
}