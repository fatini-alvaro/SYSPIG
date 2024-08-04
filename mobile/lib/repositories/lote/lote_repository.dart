
import 'package:mobile/model/lote_model.dart';

abstract class LoteRepository {

  Future<List<LoteModel>> getList(int fazendaId);

  Future<bool> delete(int loteId);

  Future<LoteModel> create(LoteModel anotacao);

  Future<LoteModel> update(LoteModel anotacao);

}