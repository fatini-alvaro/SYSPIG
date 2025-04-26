import 'package:syspig/model/anotacao_model.dart';

class DashboardModel {
  final int inseminacoesHoje;
  final int nascimentosVivos;
  final int nascimentosMortos;
  final int animaisEmBaias;
  final int anotacoesDoDia;
  final int lotesAtivos;
  final int matrizesGestando;
  final int leitoesEmCreche;
  final int movimentacoes;
  final int baiasOcupadas;
  final int baiasLivres;
  final List<AnotacaoModel>? anotacoes;

  DashboardModel({
    required this.inseminacoesHoje,
    required this.nascimentosVivos,
    required this.nascimentosMortos,
    required this.animaisEmBaias,
    required this.anotacoesDoDia,
    required this.lotesAtivos,
    required this.matrizesGestando,
    required this.leitoesEmCreche,
    required this.movimentacoes,
    required this.baiasOcupadas,
    required this.baiasLivres,
    this.anotacoes,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      inseminacoesHoje: json['inseminacoesHoje'],
      nascimentosVivos: json['nascimentosVivos'],
      nascimentosMortos: json['nascimentosMortos'],
      animaisEmBaias: json['animaisEmBaias'],
      anotacoesDoDia: json['anotacoesDoDia']['quantidade'],
      anotacoes: (json['anotacoesDoDia']['lista'] as List)
          .map((e) => AnotacaoModel.fromJson(e))
          .toList(),
      lotesAtivos: json['lotesAtivos'],
      matrizesGestando: json['matrizesGestando'],
      leitoesEmCreche: json['leitoesEmCreche'],
      movimentacoes: json['movimentacoes'],
      baiasOcupadas: json['ocupacaoBaias']['ocupadas'],
      baiasLivres: json['ocupacaoBaias']['livres'],
    );
  }
}
