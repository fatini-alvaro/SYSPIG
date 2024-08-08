import 'package:dio/dio.dart';
import 'package:syspig/model/movimentacao_model.dart';
import 'package:syspig/repositories/movimentacao/movimentacao_repository.dart';

class MovimentacaoRepositoryImp implements MovimentacaoRepository {
  @override
  Future<List<MovimentacaoModel>> getList() async {
    try {
      var response = 
        await Dio().get('http://localhost:3000/movimentacoes');
      return (response.data as List).map((e) => MovimentacaoModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}