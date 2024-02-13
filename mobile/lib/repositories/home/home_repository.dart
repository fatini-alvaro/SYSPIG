import 'package:mobile/model/post_model.dart';

abstract class HomeRepository {

  Future<List<PostModel>> getList();
}