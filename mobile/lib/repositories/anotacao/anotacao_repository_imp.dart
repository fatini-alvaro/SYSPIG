import 'package:dio/dio.dart';
import 'package:mobile/model/anotacao_model.dart';
import 'package:mobile/repositories/anotacao/anotacao_repository.dart';

class AnotacaoRepositoryImp implements AnotacaoRepository {   
  @override
  Future<List<AnotacaoModel>> getList() async {
    try {
      var response = 
          await Dio().get('http://192.168.2.204:3000/anotacoes');
        return (response.data as List).map((e) => AnotacaoModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
