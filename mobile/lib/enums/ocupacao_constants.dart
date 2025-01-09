// lib/enums/ocupacao_constants.dart

/// Enum representando o status do animal.
enum StatusOcupacao {
  aberto,
  finalizada,
}

/// Descrições para o StatusOcupacao.
const Map<StatusOcupacao, String> statusOcupacaoDescriptions = {
  StatusOcupacao.aberto: 'aberto',
  StatusOcupacao.finalizada: 'finalizada'
};

/// Mapeamento de valores inteiros para StatusOcupacao.
const Map<int, StatusOcupacao> intToStatusOcupacao = {
  1: StatusOcupacao.aberto,
  2: StatusOcupacao.finalizada,
};

/// Mapeamento de StatusOcupacao para valores inteiros.
const Map<StatusOcupacao, int> statusOcupacaoToInt = {
  StatusOcupacao.aberto: 1,
  StatusOcupacao.finalizada: 2,
};