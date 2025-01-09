// src/constants/tipoGranjaConstants.ts

export enum TipoGranjaId {
    GESTACAO = 1,
    ENGORDA = 2
}

export const TipoUsuarioIdDescriptions: Record<TipoGranjaId, string> = {
    [TipoGranjaId.GESTACAO]: 'Granja para gestação de porcas',
    [TipoGranjaId.ENGORDA]: 'Granja para engorda de suínos'
};
