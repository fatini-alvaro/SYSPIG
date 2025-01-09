// lib/enums/tipo_granja_constants.dart

/// Enum representando o id referente os tipos de granja.
enum TipoGranjaId {
  gestacao,
  engorda
}

/// Mapeamento de TipoGranjaId para valores inteiros.
const Map<TipoGranjaId, int> tipoGranjaIdToInt = {
  TipoGranjaId.gestacao: 1,
  TipoGranjaId.engorda: 2
};