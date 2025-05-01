export enum TipoUsuarioId {
  DONO = 1,
  FUNCIONARIO = 2,
}

export const TipoUsuarioIdDescriptions: Record<TipoUsuarioId, string> = {
  [TipoUsuarioId.DONO]: 'Administrador',
  [TipoUsuarioId.FUNCIONARIO]: 'Funcionário',
};
