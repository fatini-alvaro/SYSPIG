import 'package:dio/dio.dart';
import 'package:mobile/model/baia_model.dart';
import 'package:mobile/repositories/baia/baia_repository.dart';

class BaiaRepositoryImp implements BaiaRepository {   
  @override
  Future<List<BaiaModel>> getList() async {
    try {
      var response = 
          await Dio().get('http://192.168.2.204:3000/baias');
        return (response.data as List).map((e) => BaiaModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
