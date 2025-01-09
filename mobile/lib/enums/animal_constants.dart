// lib/enums/animal_constants.dart

/// Enum representando o sexo do animal.
enum SexoAnimal {
  macho,
  femea,
}

/// Descrições para o SexoAnimal.
const Map<SexoAnimal, String> sexoAnimalDescriptions = {
  SexoAnimal.macho: 'Macho',
  SexoAnimal.femea: 'Fêmea',
};

extension SexoAnimalExtension on SexoAnimal {
  String toShortString() {
    switch (this) {
      case SexoAnimal.macho:
        return 'M';
      case SexoAnimal.femea:
        return 'F';
    }
  }
}

SexoAnimal sexoFromApi(String? apiValue) {
  switch (apiValue) {
    case 'M':
      return SexoAnimal.macho;
    case 'F':
      return SexoAnimal.femea;
    default:
      return SexoAnimal.femea; // Valor padrão
  }
}

/// Enum representando o status do animal.
enum StatusAnimal {
  vivo,
  morto,
  vendido,
}

/// Descrições para o StatusAnimal.
const Map<StatusAnimal, String> statusAnimalDescriptions = {
  StatusAnimal.vivo: 'Vivo',
  StatusAnimal.morto: 'Morto',
  StatusAnimal.vendido: 'Vendido',
};

/// Mapeamento de valores inteiros para StatusAnimal.
const Map<int, StatusAnimal> intToStatusAnimal = {
  1: StatusAnimal.vivo,
  2: StatusAnimal.morto,
  3: StatusAnimal.vendido,
};

/// Mapeamento de StatusAnimal para valores inteiros.
const Map<StatusAnimal, int> statusAnimalToInt = {
  StatusAnimal.vivo: 1,
  StatusAnimal.morto: 2,
  StatusAnimal.vendido: 3,
};

