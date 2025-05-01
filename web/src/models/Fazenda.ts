export interface Fazenda {
  id: number;
  nome: string;
  cidade?: {
    nome: string;
    uf?: {
      sigla: string;
    };
  };
}
