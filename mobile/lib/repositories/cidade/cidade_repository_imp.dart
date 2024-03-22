import 'package:mobile/model/cidade_model.dart';
import 'package:mobile/repositories/cidade/cidade_repository.dart';
import 'package:dio/dio.dart';

class CidadeRepositoryImp implements CidadeRepository {   
  @override
  Future<List<CidadeModel>> getList() async {
    try {
      var response = 
          await Dio().get('http://localhost:3000/cidades');
        return (response.data as List).map((e) => CidadeModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
