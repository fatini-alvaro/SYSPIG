import 'package:syspig/model/fazenda_model.dart';

abstract class FazendaRepository {

  //retorna fazendas pelo id do usuario
  Future<List<FazendaModel>> getList(int userId);

  Future<FazendaModel> create(FazendaModel fazenda);

}