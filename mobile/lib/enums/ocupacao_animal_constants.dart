// lib/enums/ocupacao_animak_constants.dart

/// Enum representando o status da ocupacao do animal.
enum StatusOcupacaoAnimal {
  ativo,
  removido,
}

/// Descrições para o StatusOcupacaoAnimal.
const Map<StatusOcupacaoAnimal, String> statusOcupacaoAnimalDescriptions = {
  StatusOcupacaoAnimal.ativo: 'ativo',
  StatusOcupacaoAnimal.removido: 'removido'
};

/// Mapeamento de valores inteiros para StatusOcupacaoAnimal.
const Map<int, StatusOcupacaoAnimal> intToStatusOcupacaoAnimal = {
  1: StatusOcupacaoAnimal.ativo,
  2: StatusOcupacaoAnimal.removido,
};

/// Mapeamento de StatusOcupacaoAnimal para valores inteiros.
const Map<StatusOcupacaoAnimal, int> statusOcupacaoToInt = {
  StatusOcupacaoAnimal.ativo: 1,
  StatusOcupacaoAnimal.removido: 2,
};