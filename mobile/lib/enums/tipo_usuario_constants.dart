// lib/enums/tipo_granja_constants.dart

/// Enum representando o id referente aos tipos de usuario.
enum TipoUsuarioId {
  dono,
  funcionario
}

/// Mapeamento de TipoUsuarioId para valores inteiros.
const Map<TipoUsuarioId, int> tipoUsuarioIdToInt = {
  TipoUsuarioId.dono: 1,
  TipoUsuarioId.funcionario: 2
};