// src/constants/tipoUsuarioConstants.ts

export enum TipoUsuarioId {
    DONO = 1,
    FUNCIONARIO = 2
}

export const TipoUsuarioIdDescriptions: Record<TipoUsuarioId, string> = {
    [TipoUsuarioId.DONO]: 'Dono ou sócio da fazenda',
    [TipoUsuarioId.FUNCIONARIO]: 'Funcionário',
};
