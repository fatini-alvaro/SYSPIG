import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository.dart';

class OcupacaoController {
  final OcupacaoRepository _ocupacaoRepository;
  OcupacaoController(this._ocupacaoRepository);

  Future<OcupacaoModel> fetchOcupacaoById(int ocupacaoId) async {
    
    OcupacaoModel ocupacao = await  _ocupacaoRepository.getById(ocupacaoId);

    return ocupacao;
  }

  Future<OcupacaoModel> create(OcupacaoModel ocupacaoNova) async {

    OcupacaoModel novaOcupacao = await  _ocupacaoRepository.create(ocupacaoNova);

    return novaOcupacao;
  }

  Future<OcupacaoModel> fetchBaiaById(int baiaId) async {
    
    OcupacaoModel baia = await  _ocupacaoRepository.getByBaiaId(baiaId);

    return baia;
  }

  Future<OcupacaoModel> fetchOcupacaoByBaia(int baiaId) async {
    
    OcupacaoModel ocupacao = await  _ocupacaoRepository.getByBaiaId(baiaId);

    return ocupacao;
  }
  
}