
import 'package:logger/logger.dart';
import 'package:syspig/api/api_cliente.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository.dart';

class OcupacaoRepositoryImp implements OcupacaoRepository {   

  late final ApiClient _apiClient;

  OcupacaoRepositoryImp() {
    _apiClient = ApiClient();
  }  
  
  @override
  Future<OcupacaoModel> create(OcupacaoModel ocupacao) async {
    try {
      Map<String, dynamic> ocupacaoData = {
        'animal_id': ocupacao.animal!.id,
        'baia_id': ocupacao.baia!.id,
        'granja_id': ocupacao.granja!.id,
      };

      var response = await _apiClient.dio.post('/ocupacoes', data: ocupacaoData);
      return OcupacaoModel.fromJson(response.data);
    } catch (e) {      
      Logger().e('Erro ao criar ocupacao (create - Ocupacoes): $e');
      throw Exception('Erro ao criar ocupacao');
    }
  }

}
