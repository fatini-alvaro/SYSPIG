import 'package:mobile/model/animal_model.dart';
import 'package:mobile/model/baia_model.dart';
import 'package:mobile/model/fazenda_model.dart';

class AnotacaoModel {
  final int? id;
  final FazendaModel? fazenda;
  final String? descricao;
  final AnimalModel? animal;
  final BaiaModel? baia;
  // final TipoGranjaModel matriz;
  // final TipoGranjaModel pai;

  AnotacaoModel({
    this.id,
    this.fazenda,
    this.descricao,
    this.animal,
    this.baia
  });

  factory AnotacaoModel.fromJson(Map<String, dynamic> json) {
    return AnotacaoModel(
      id: json['id'],
      fazenda: json['fazenda'] != null ? FazendaModel.fromJson(json['fazenda']) : null,
      descricao: json['descricao'],
      animal: json['animal'] != null ? AnimalModel.fromJson(json['animal']) : null,
      baia: json['baia'] != null ? BaiaModel.fromJson(json['baia']) : null,
    );
  }

  @override
  String toString() {
    return 'id: $id, fazenda: $fazenda, descricao: $descricao, animal: $animal, baia: $baia';
  }
}
