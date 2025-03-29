import { AppDataSource } from "../data-source";
import { Movimentacao } from "../entities/movimentacao";

export class MovimentacaoService {
    private movimentacaoRepository = AppDataSource.getRepository(Movimentacao);

    async listByFazenda(fazenda_id: number) {
        return await this.movimentacaoRepository.find({
            where: {
                animal: {
                    fazenda: { id: fazenda_id }
                }
            },
            relations: ['animal', 'baiaOrigem', 'baiaDestino', 'usuario'],
            order: { dataMovimentacao: "DESC" }
        });
    }

    async getHistoricoAnimal(animal_id: number) {
        return await this.movimentacaoRepository.find({
            where: { animal: { id: animal_id } },
            relations: ['baiaOrigem', 'baiaDestino', 'usuario'],
            order: { dataMovimentacao: "DESC" }
        });
    }
}