import 'package:mobile/model/fazenda_model.dart';

class AnimalModel {
  final int id;
  final String numeroBrinco;
  final FazendaModel fazenda;
  final String sexo;
  final String status;
  final int dataNascimento;
  // final FazendaModel baia;
  // final TipoGranjaModel matriz;
  // final TipoGranjaModel pai;

  AnimalModel({
    required this.id,
    required this.numeroBrinco,
    required this.fazenda,
    required this.sexo,
    required this.status,
    required this.dataNascimento,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['id'],
      numeroBrinco: json['numero_brinco'],
      sexo: json['sexo'],
      status: json['status'],
      fazenda: FazendaModel.fromJson(json['fazenda']),
      dataNascimento: json['data_nascimento'],
    );
  }

  @override
  String toString() {
    return 'id: $id, numero_brinco: $numeroBrinco, sexo: $sexo, status: $status, fazenda: $fazenda, data_nascimento: $dataNascimento';
  }
}
