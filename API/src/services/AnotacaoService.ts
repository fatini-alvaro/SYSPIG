import { AppDataSource } from "../data-source";
import { Anotacao } from "../entities/Anotacao";
import { anotacaoRepository } from "../repositories/anotacaoRepository";
import { Usuario } from "../entities/Usuario";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";

interface AnotacaoCreateOrUpdateData {
  descricao: string;
  animal_id: number;
  baia_id: number;
  fazenda_id: number;
  ocupacao_id: number;
  usuarioIdAcao: number;
  data: Date;
}

export class AnotacaoService {

  async list(fazenda_id: number) {
    return await anotacaoRepository.find({ 
      where: { 
        fazenda: { 
          id: Number(fazenda_id) 
        } 
      },
      select: ['id', 'descricao'],
      order: { id: 'DESC' }
    });
  }

  async listByBaia(baia_id: number) {
    return await anotacaoRepository.find({ 
      where: {
        baia: {
          id: Number(baia_id),
        },
      },
      order: {
        data: 'DESC'
      }
    });
  }
  
  async createOrUpdate(anotacaoData: AnotacaoCreateOrUpdateData, anotacao_id?: number) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      let anotacao: Anotacao | null = null;

      if (anotacao_id) {
        anotacao = await ValidationService.validateAndReturnAnotacao(anotacao_id);
      }

      const { fazenda, animalInstancia, baiaInstancia, createdBy, updatedBy, ocupacaoInstancia } =
        await this.validateAnotacao(anotacaoData, anotacao);

      if (!anotacao) {
        anotacao = transactionalEntityManager.create(Anotacao, { fazenda });
      }

      anotacao.descricao = anotacaoData.descricao;
      anotacao.animal = animalInstancia ?? null;
      anotacao.baia = baiaInstancia ?? null;
      anotacao.ocupacao = ocupacaoInstancia ?? null;
      anotacao.data = anotacaoData.data;
      anotacao.createdBy = createdBy ?? anotacao.createdBy;
      anotacao.updatedBy = updatedBy ?? anotacao.updatedBy;

      await transactionalEntityManager.save(anotacao);
      return anotacao;
    });
  }

  async delete(anotacao_id: number): Promise<void> {
    if (!anotacao_id) {
      throw new ValidationError('Parâmetros não informados');
    }

    await AppDataSource.transaction(async (transactionalEntityManager) => {
      await transactionalEntityManager.delete(Anotacao, anotacao_id);
    });
  }

  async getById(anotacao_id: number) {
    return await anotacaoRepository.findOne({ where: { id: anotacao_id } });
  }

  async validateAnotacao(anotacaoData: AnotacaoCreateOrUpdateData, anotacao?: Anotacao | null) {
    const fazenda = await ValidationService.validateAndReturnFazenda(anotacaoData.fazenda_id);

    if (!anotacaoData.descricao || anotacaoData.descricao.trim() === '') {
      throw new ValidationError('A descrição é obrigatória.');
    }

    if (anotacaoData.descricao.length > 500) {
      throw new ValidationError('A descrição não pode ter mais de 500 caracteres.');
    }

    const animalInstancia = await ValidationService.validateAndReturnAnimal(anotacaoData.animal_id, fazenda);
    const baiaInstancia = await ValidationService.validateAndReturnBaia(anotacaoData.baia_id, fazenda);
    const ocupacaoInstancia = await ValidationService.validateAndReturnOcupacao(anotacaoData.ocupacao_id);

    let createdBy: Usuario | null = null;
    let updatedBy: Usuario | null = null;

    if (anotacao) {
      updatedBy = await ValidationService.validateAndReturnUsuario(anotacaoData.usuarioIdAcao);
    } else {
      createdBy = await ValidationService.validateAndReturnUsuario(anotacaoData.usuarioIdAcao);
    }

    return {
      fazenda,
      animalInstancia,
      baiaInstancia,
      ocupacaoInstancia,
      createdBy,
      updatedBy,
    };
  }

}
