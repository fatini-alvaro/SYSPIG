import 'package:syspig/enums/tipo_granja_constants.dart';
import 'package:syspig/model/baia_com_leitoes_model.dart';
import 'package:syspig/model/baia_model.dart';

abstract class BaiaRepository {

  Future<List<BaiaModel>> getList(int granjaId);

  Future<List<BaiaModel>> getListAll(int fazendaId);

  Future<List<BaiaComLeitoesModel>> getListBaiasComLeitoesParaVenda(int fazendaId);

  Future<List<BaiaModel>> getListByFazendaAndTipo(int fazendaId, TipoGranjaId tipoGranja);

  Future<BaiaModel> getById(int baiaId);

  Future<BaiaModel> create(BaiaModel baia);

  Future<BaiaModel> update(BaiaModel baia);

  Future<bool> delete(int baiaId);
}