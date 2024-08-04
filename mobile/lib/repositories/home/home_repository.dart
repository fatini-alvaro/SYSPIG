import 'package:syspig/model/post_model.dart';

abstract class HomeRepository {

  Future<List<PostModel>> getList();
}