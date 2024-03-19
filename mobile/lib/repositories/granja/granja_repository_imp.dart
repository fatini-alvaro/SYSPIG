import 'package:dio/dio.dart';
import 'package:mobile/model/granja_model.dart';
import 'package:mobile/repositories/granja/granja_repository.dart';

class GranjaRepositoryImp implements GranjaRepository {   
  @override
  Future<List<GranjaModel>> getList() async {
    try {
      var response = 
          await Dio().get('http://192.168.2.201:3000/granjas/2');
        return (response.data as List).map((e) => GranjaModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
