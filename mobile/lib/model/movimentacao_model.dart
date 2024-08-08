import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/fazenda_model.dart';

class MovimentacaoModel {
  final int id;
  final FazendaModel? fazenda;
  final AnimalModel? animal;
  //Tratar a data de forma correta:
  final int dataMovimento;
  //Alterar para classe do tipo baia:
  // final int baiaEntrada;
  // final int baiaSaida;

  MovimentacaoModel({
    required this.id,
    this.fazenda,
    this.animal,
    required this.dataMovimento,
    // required this.baiaEntrada,
    // required this.baiaSaida,
  });

  factory MovimentacaoModel.fromJson(Map<String, dynamic> json) {
    return MovimentacaoModel(
      id: json['id'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      animal: json['Animal'] != null ? AnimalModel.fromJson(json['Animal']) : null,
      dataMovimento: json['data_movimento'],
      // baiaEntrada: BaiaModel.fromJson(json['BaiaEntrada']) ,
      // baiaSaida: BaiaModel.fromJson(json['BaiaSaida']) ,
    );
  }

  @override
  String toString() {
    return 'id: $id, animal: $animal, fazenda: $fazenda, data_movimento: $dataMovimento';
  }
}