// src/constants/ocupacaoConstants.ts

export enum StatusOcupacao {
    ABERTA = 1,
    FINALIZADA = 2,
}

// Mapeamento dos códigos para as descrições
export const StatusOcupacaoDescriptions: Record<StatusOcupacao, string> = {
    [StatusOcupacao.ABERTA]: 'Ocupacao aind esta em aberto',
    [StatusOcupacao.FINALIZADA]: 'Ocupacao ja foi finalizada',
};