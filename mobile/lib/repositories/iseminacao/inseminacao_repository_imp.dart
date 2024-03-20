import 'package:dio/dio.dart';
import 'package:mobile/model/inseminacao_model.dart';
import 'package:mobile/repositories/iseminacao/inseminacao_repository.dart';

class InseminacaoRepositoryImp implements InseminacaoRepository {   
  @override
  Future<List<InseminacaoModel>> getList() async {
    try {
      var response = 
          await Dio().get('http://localhost:3000/inseminacoes');
        return (response.data as List).map((e) => InseminacaoModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
