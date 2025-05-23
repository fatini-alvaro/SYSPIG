import 'package:logger/logger.dart';
import 'package:syspig/model/post_model.dart';
import 'package:syspig/repositories/home/home_repository.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImp implements HomeRepository {   
  @override
  Future<List<PostModel>> getList() async {
    try {
      var response = 
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
        return (response.data as List).map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      Logger().e(e);
    }

    return [];
  }
}
