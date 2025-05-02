import 'package:syspig/enums/animal_constants.dart';
import 'package:syspig/model/venda_model.dart';

abstract class VendaRepository {

  Future<List<VendaModel>> getList(int fazendaId);

  Future<bool> createVenda({
    required DateTime data_venda,
    required int quantidadeVendida,
    required double valorVenda,
    required double peso,
    required List<Map<String, int>> animais
  });
}