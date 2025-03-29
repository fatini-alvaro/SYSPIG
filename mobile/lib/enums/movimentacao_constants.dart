/// Enum representando os tipos de movimentação
enum TipoMovimentacao {
  entrada,
  transferencia,
  saida,
}

/// Descrições para TipoMovimentacao
const Map<TipoMovimentacao, String> tipoMovimentacaoDescriptions = {
  TipoMovimentacao.entrada: 'Entrada',
  TipoMovimentacao.transferencia: 'Transferência',
  TipoMovimentacao.saida: 'Saída',
};

/// Mapeamento de valores inteiros para TipoMovimentacao
const Map<int, TipoMovimentacao> intToTipoMovimentacao = {
  1: TipoMovimentacao.entrada,
  2: TipoMovimentacao.transferencia,
  3: TipoMovimentacao.saida,
};

/// Mapeamento de TipoMovimentacao para valores inteiros
const Map<TipoMovimentacao, int> tipoMovimentacaoToInt = {
  TipoMovimentacao.entrada: 1,
  TipoMovimentacao.transferencia: 2,
  TipoMovimentacao.saida: 3,
};

/// Enum representando o status da movimentação
enum StatusMovimentacao {
  ativa,
  historico,
}

/// Descrições para StatusMovimentacao
const Map<StatusMovimentacao, String> statusMovimentacaoDescriptions = {
  StatusMovimentacao.ativa: 'Ativa',
  StatusMovimentacao.historico: 'Histórico',
};

/// Mapeamento de valores inteiros para StatusMovimentacao
const Map<int, StatusMovimentacao> intToStatusMovimentacao = {
  1: StatusMovimentacao.ativa,
  2: StatusMovimentacao.historico,
};

/// Mapeamento de StatusMovimentacao para valores inteiros
const Map<StatusMovimentacao, int> statusMovimentacaoToInt = {
  StatusMovimentacao.ativa: 1,
  StatusMovimentacao.historico: 2,
};

/// Extensões úteis para os enums
extension TipoMovimentacaoExtension on TipoMovimentacao {
  /// Retorna a descrição formatada
  String get description => tipoMovimentacaoDescriptions[this] ?? 'Desconhecido';
  
  /// Retorna o valor inteiro correspondente
  int toInt() => tipoMovimentacaoToInt[this] ?? 1;
}

extension StatusMovimentacaoExtension on StatusMovimentacao {
  /// Retorna a descrição formatada
  String get description => statusMovimentacaoDescriptions[this] ?? 'Desconhecido';
  
  /// Retorna o valor inteiro correspondente
  int toInt() => statusMovimentacaoToInt[this] ?? 1;
}

/// Funções de conversão para a API
TipoMovimentacao tipoMovimentacaoFromApi(int? apiValue) {
  return intToTipoMovimentacao[apiValue ?? 1] ?? TipoMovimentacao.entrada;
}

StatusMovimentacao statusMovimentacaoFromApi(int? apiValue) {
  return intToStatusMovimentacao[apiValue ?? 1] ?? StatusMovimentacao.ativa;
}