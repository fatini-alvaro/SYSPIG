// src/constants/movimentacaoConstants.ts

export enum TipoMovimentacao {
    ENTRADA = 1,       // Quando o animal é alocado pela primeira vez em uma baia
    TRANSFERENCIA = 2,  // Quando o animal é transferido de uma baia para outra
    SAIDA = 3,         // Quando o animal é removido do sistema (venda, morte, etc.)
}

// Mapeamento dos códigos para as descrições
export const TipoMovimentacaoDescriptions: Record<TipoMovimentacao, string> = {
    [TipoMovimentacao.ENTRADA]: 'Entrada do animal no sistema',
    [TipoMovimentacao.TRANSFERENCIA]: 'Transferência entre baias',
    [TipoMovimentacao.SAIDA]: 'Saída do animal do sistema',
};

export enum StatusMovimentacao {
    ATIVA = 1,         // Movimentação recente, ainda em vigor
    HISTORICO = 2,     // Movimentação antiga, registrada apenas para histórico
}

export const StatusMovimentacaoDescriptions: Record<StatusMovimentacao, string> = {
    [StatusMovimentacao.ATIVA]: 'Movimentação ativa',
    [StatusMovimentacao.HISTORICO]: 'Movimentação histórica',
};