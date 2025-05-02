import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/ocupacao_model.dart';

class BaiaComLeitoesModel {
  final int id;
  final String numero;
  final bool vazia;
  final String? granjaDescricao;
  final List<AnimalModel> leitoes;
  OcupacaoModel? ocupacao;

  BaiaComLeitoesModel({
    required this.id,
    required this.numero,
    required this.vazia,
    this.granjaDescricao,
    required this.leitoes,
    this.ocupacao,
  });

  factory BaiaComLeitoesModel.fromJson(Map<String, dynamic> json) {
    return BaiaComLeitoesModel(
      id: json['id'],
      numero: json['numero'],
      vazia: json['vazia'],
      granjaDescricao: json['granja']?['descricao'],
      ocupacao: json['ocupacao'] != null ? OcupacaoModel.fromJson(json['ocupacao']) : null,
      leitoes: (json['ocupacao']?['ocupacaoAnimais'] as List<dynamic>? ?? [])
          .map((oa) => AnimalModel.fromJson(oa['animal']))
          .toList(),
    );
  }
}
