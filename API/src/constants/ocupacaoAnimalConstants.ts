// src/constants/OcupacaoAnimalConstants.ts

export enum StatusOcupacaoAnimal {
    ATIVO = 1,
    REMOVIDO = 2
}

// Mapeamento dos códigos para descrições
export const StatusOcupacaoAnimalDescriptions: Record<StatusOcupacaoAnimal, string> = {
    [StatusOcupacaoAnimal.ATIVO]: 'Ativo',
    [StatusOcupacaoAnimal.REMOVIDO]: 'Removido',
};
