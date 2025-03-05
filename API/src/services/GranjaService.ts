import { AppDataSource } from "../data-source";
import { Usuario } from "../entities/Usuario";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { granjaRepository } from "../repositories/granjaRepository";
import { Granja } from "../entities/Granja";

interface GranjaCreateOrUpdateData {
  fazenda_id: number;
  tipo_granja_id: number;
  descricao: string;
  usuarioIdAcao: number;
}

export class GranjaService {

  async list(fazenda_id: number) {
    return await granjaRepository.find({ 
      where: { 
        fazenda: { 
          id: Number(fazenda_id) 
        } 
      },
      relations: ['tipoGranja', 'fazenda'],
      select: {
        id: true,
        descricao: true,
        tipoGranja: {
          descricao: true,
        },
        fazenda: {
          nome: true,
        },
      },
      order: { id: 'ASC' }
    });
  }
  
  async createOrUpdate(granjaData: GranjaCreateOrUpdateData, granja_id?: number) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      let granja: Granja | null = null;

      if (granja_id) {
        granja = await ValidationService.validateAndReturnGranja(granja_id);
      }

      const { fazenda, tipoGranjaInstancia, createdBy, updatedBy } =
        await this.validateGranja(granjaData, granja);

      if (!granja) {
        granja = transactionalEntityManager.create(Granja, { fazenda });
      }

      granja.descricao = granjaData.descricao;
      granja.tipoGranja = tipoGranjaInstancia!;
      granja.createdBy = createdBy ?? granja.createdBy;
      granja.updatedBy = updatedBy ?? granja.updatedBy;

      await transactionalEntityManager.save(granja);
      return granja;
    });
  }

  async delete(granja_id: number): Promise<void> {
    if (!granja_id) {
      throw new ValidationError('Parâmetros não informados');
    }

    await AppDataSource.transaction(async (transactionalEntityManager) => {
      await transactionalEntityManager.delete(Granja, granja_id);
    });
  }

  async getById(granja_id: number) {
    return await granjaRepository.findOne({ where: { id: granja_id } });
  }

  async validateGranja(granjaData: GranjaCreateOrUpdateData, granja?: Granja | null) {
    const fazenda = await ValidationService.validateAndReturnFazenda(granjaData.fazenda_id);

    if (!granjaData.descricao || granjaData.descricao.trim() === '') {
      throw new ValidationError('A descrição é obrigatória.');
    }

    if (granjaData.descricao.length > 500) {
      throw new ValidationError('A descrição não pode ter mais de 500 caracteres.');
    }

    // Verificar se já existe uma granja com a mesma descrição na mesma fazenda
    const granjaExistente = await granjaRepository.findOne({
      where: { 
        descricao: granjaData.descricao, 
        fazenda: { id: granjaData.fazenda_id } 
      }
    });

    if (granjaExistente && (!granja || granjaExistente.id !== granja.id)) {
      throw new ValidationError('Já existe uma granja com essa descrição nesta fazenda.');
    }

    const tipoGranjaInstancia = await ValidationService.validateAndReturnTipoGranja(granjaData.tipo_granja_id);

    let createdBy: Usuario | null = null;
    let updatedBy: Usuario | null = null;

    if (granja) {
      updatedBy = await ValidationService.validateAndReturnUsuario(granjaData.usuarioIdAcao);
    } else {
      createdBy = await ValidationService.validateAndReturnUsuario(granjaData.usuarioIdAcao);
    }

    return {
      fazenda,
      tipoGranjaInstancia,
      createdBy,
      updatedBy,
    };
  }

}
