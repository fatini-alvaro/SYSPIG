import 'package:mobile/model/fazenda_model.dart';
import 'package:mobile/repositories/fazenda/fazenda_repository.dart';
import 'package:dio/dio.dart';

class FazendaRepositoryImp implements FazendaRepository {   
  @override
  Future<List<FazendaModel>> getList(int userId) async {
    try {
      var response = 
          await Dio().get('http://192.168.2.201:3000/usuariofazendas/$userId');
        return (response.data as List).map((e) => FazendaModel.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }

    return [];
  }
}
