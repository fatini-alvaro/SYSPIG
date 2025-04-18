// src/constants/tipoGranjaConstants.ts

export enum TipoGranjaId {
    GESTACAO = 1,
    GERAL = 2,
    CRECHE = 3,
    INSEMINACAO = 4,
}

export const TipoGranjaIdDescriptions: Record<TipoGranjaId, string> = {
    [TipoGranjaId.GESTACAO]: 'Granja para gestação de porcas',
    [TipoGranjaId.GERAL]: 'Granja para uso geral',
    [TipoGranjaId.CRECHE]: 'Granja para crechário de leitões',
    [TipoGranjaId.INSEMINACAO]: 'Granja para inseminação de porcas',
};
