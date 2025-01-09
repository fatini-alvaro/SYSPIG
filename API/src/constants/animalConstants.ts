// src/constants/animalConstants.ts

export enum SexoAnimal {
    MACHO = 'M',
    FEMEA = 'F'
}

export const SexoAnimalDescriptions: Record<SexoAnimal, string> = {
    [SexoAnimal.MACHO]: 'Macho',
    [SexoAnimal.FEMEA]: 'Fêmea',
};

export enum StatusAnimal {
    VIVO = 1,
    MORTO = 2,
    VENDIDO = 3
}

// Mapeamento dos códigos para as descrições
export const StatusAnimalDescriptions: Record<StatusAnimal, string> = {
    [StatusAnimal.VIVO]: 'Vivo',
    [StatusAnimal.MORTO]: 'Morto',
    [StatusAnimal.VENDIDO]: 'Vendido',
};
