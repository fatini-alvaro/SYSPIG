import 'package:dio/dio.dart';
import 'package:mobile/model/lote_model.dart';
import 'package:mobile/repositories/lote/lote_repository.dart';

class LoteRepositoryImp implements LoteRepository {   
  @override
  Future<List<LoteModel>> getList() async {
    try {
      var response = 
          await Dio().get('http://192.168.2.204:3000/lotes');
        return (response.data as List).map((e) => LoteModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
