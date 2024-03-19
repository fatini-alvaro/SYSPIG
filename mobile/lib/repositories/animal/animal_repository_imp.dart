import 'package:dio/dio.dart';
import 'package:mobile/model/animal_model.dart';
import 'package:mobile/repositories/animal/animal_repository.dart';

class AnimalRepositoryImp implements AnimalRepository {   
  @override
  Future<List<AnimalModel>> getList() async {
    try {
      var response = 
          await Dio().get('http://192.168.2.201:3000/animais');
        return (response.data as List).map((e) => AnimalModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
