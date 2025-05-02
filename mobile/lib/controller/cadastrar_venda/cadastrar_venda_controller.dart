import 'package:flutter/material.dart';
import 'package:syspig/controller/ocupacao/ocupacao_controller.dart';
import 'package:syspig/model/baia_com_leitoes_model.dart';
import 'package:syspig/model/ocupacao_model.dart';
import 'package:syspig/repositories/baia/baia_repository_imp.dart';
import 'package:syspig/repositories/ocupacao/ocupacao_repository_imp.dart';
import 'package:syspig/repositories/venda/venda_repository_imp.dart';
import 'package:syspig/services/prefs_service.dart';
import 'package:syspig/utils/async_fetcher_util.dart';
import 'package:syspig/utils/async_handler_util.dart';

class CadastrarVendaController with ChangeNotifier {
  final OcupacaoController _ocupacaoController = OcupacaoController(OcupacaoRepositoryImp());
  final BaiaRepositoryImp _baiaRepository = BaiaRepositoryImp();
  final VendaRepositoryImp _vendaRepository = VendaRepositoryImp();

  final List<BaiaComLeitoesModel> _baias = [];
  List<BaiaComLeitoesModel> get baias => _baias;

  double? _peso;
  setPeso(double? value) => _peso = value;
  double? get peso => _peso;

  double? _valor;
  setValor(double? value) => _valor = value;
  double? get valor => _valor;

  DateTime? _data;
  setData(DateTime? value) => _data = value;
  DateTime? get data => _data;

  Future<List<BaiaComLeitoesModel>> getBaiasCrecheComLeitoesFromRepository() async {
    return await AsyncFetcher.fetch(
      action: () async {
        var idFazenda = await PrefsService.getFazendaId();
        return await _baiaRepository.getListBaiasComLeitoesParaVenda(idFazenda!);
      },
      errorMessage: 'Erro ao buscar as baias do repositório',
    ) ?? [];
  }

  Future<OcupacaoModel?> getOcupacaoByBaia(int baiaId) async {
    return await AsyncFetcher.fetch(
      action: () async {
        final ocupacao = await _ocupacaoController.fetchOcupacaoByBaia(baiaId);
        if (ocupacao == null) {
          throw Exception('Ocupação não encontrada para a baia $baiaId');
        }
        return ocupacao;
      },
      errorMessage: 'Erro ao buscar ocupação da baia',
    );
  }

  Future<bool> cadastrarVenda(BuildContext context) async {
    final vendaRealizada = await AsyncHandler.execute(
      context: context,
      action: () async {
        if (_baias.isEmpty || _peso == null || _valor == null || _data == null) {
          throw Exception('Selecione os campos obrigatórios');
        }

        return await _vendaRepository.createVenda(
          data_venda: _data!,
          quantidadeVendida: _baias.fold<int>(0, (total, baia) => total + baia.leitoes.length),
          valorVenda: _valor!,
          peso: _peso!,
          animais: _baias.expand((baia) {
            return baia.leitoes.map((leitao) {
              return {
                'animal_id': leitao.id!,
                'baia_id': baia.id!,
              };
            });
          }).toList(),
        );
      },
      loadingMessage: 'Aguarde, realizando Venda',
      successMessage: 'Venda criada com sucesso!',
    );

    return vendaRealizada != null;
  }
}