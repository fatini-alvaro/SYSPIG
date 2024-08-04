import 'package:syspig/model/animal_model.dart';
import 'package:syspig/model/fazenda_model.dart';

class MovimentacaoModel {
  final int id;
  final FazendaModel fazenda;
  final AnimalModel animal;
  //Tratar a data de forma correta:
  final int dataMovimento;
  //Alterar para classe do tipo baia:
  // final int baiaEntrada;
  // final int baiaSaida;

  MovimentacaoModel({
    required this.id,
    required this.fazenda,
    required this.animal,
    required this.dataMovimento,
    // required this.baiaEntrada,
    // required this.baiaSaida,
  });

  factory MovimentacaoModel.fromJson(Map<String, dynamic> json) {
    return MovimentacaoModel(
      id: json['id'],
      fazenda: FazendaModel.fromJson(json['fazenda']),
      animal: AnimalModel.fromJson(json['Animal']),
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