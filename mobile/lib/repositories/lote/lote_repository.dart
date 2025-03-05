
import 'package:syspig/model/lote_model.dart';

abstract class LoteRepository {

  Future<List<LoteModel>> getList(int fazendaId);

  Future<bool> delete(int loteId);

  Future<LoteModel> create(LoteModel lote);

  Future<LoteModel> update(LoteModel lote);

  Future<LoteModel> getById(int loteId);

}