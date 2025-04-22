import { AppDataSource } from "../data-source";
import { Baia } from "../entities/Baia";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { Usuario } from "../entities/Usuario";
import { baiaRepository } from "../repositories/baiaRepository";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";

interface BaiaCreateOrUpdateData {
  numero: string;
  granja_id: number;
  fazenda_id: number;
  usuarioIdAcao: number;
}

export class BaiaService {

  async createOrUpdate(baiaData: BaiaCreateOrUpdateData, baia_id?: number) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      let baia: Baia | null = null;

      if (baia_id) {
        baia = await ValidationService.validateAndReturnBaia(baia_id);
      }

      const { fazenda, granjaInstancia, createdBy, updatedBy } =
        await this.validateBaia(baiaData, baia);

      if (!baia) {
        baia = transactionalEntityManager.create(Baia, { fazenda });
      }

      baia.numero = baiaData.numero;
      baia.granja = granjaInstancia!;
      baia.vazia = true;
      baia.createdBy = createdBy ?? baia.createdBy;
      baia.updatedBy = updatedBy ?? baia.updatedBy;

      await transactionalEntityManager.save(baia);
      return baia;
    });
  }

  async listByGranja(granja_id: number) {
    return await baiaRepository.createQueryBuilder("baia")
      .leftJoinAndSelect("baia.ocupacao", "ocupacao")
      .leftJoinAndSelect("baia.granja", "granja")
      .leftJoinAndSelect("granja.tipoGranja", "tipoGranja")
      .leftJoinAndSelect("ocupacao.ocupacaoAnimais", "ocupacaoAnimais", "ocupacaoAnimais.status = :statusAtivo", { statusAtivo: StatusOcupacaoAnimal.ATIVO })
      .leftJoinAndSelect("ocupacaoAnimais.animal", "animal")
      .select([
        "baia.id", 
        "baia.numero", 
        "baia.vazia", 
        "ocupacao.id",
        "ocupacao.codigo",
        "ocupacaoAnimais.id",
        "animal.id",
        "animal.data_ultima_inseminacao",
        "animal.nascimento",
        "granja.id",
        "granja.descricao",
        "granja.tipo_granja_id",
      ])
      .where("baia.granja_id = :granja_id", { granja_id })
      .orderBy({ 
        "baia.vazia": "ASC", 
        "baia.numero": "DESC" 
      })
      .getMany();
  }  

  async listByFazenda(fazenda_id: number) {
    return await baiaRepository.createQueryBuilder("baia")
      .leftJoinAndSelect("baia.ocupacao", "ocupacao")
      .leftJoinAndSelect("baia.granja", "granja")
      .leftJoinAndSelect("granja.tipoGranja", "tipoGranja")
      .leftJoinAndSelect("ocupacao.ocupacaoAnimais", "ocupacaoAnimais", "ocupacaoAnimais.status = :statusAtivo", { statusAtivo: StatusOcupacaoAnimal.ATIVO })
      .leftJoinAndSelect("ocupacaoAnimais.animal", "animal")
      .select([
        "baia.id", 
        "baia.numero", 
        "baia.vazia", 
        "ocupacao.id",
        "ocupacao.codigo",
        "ocupacaoAnimais.id",
        "animal.id",
        "animal.data_ultima_inseminacao",
        "animal.nascimento",
        "granja.id",
        "granja.descricao",
        "granja.codigo",
        "tipoGranja.id",
        "tipoGranja.descricao",
      ])
      .where("baia.fazenda_id = :fazenda_id", { fazenda_id })
      .orderBy({ 
        "baia.vazia": "ASC", 
        "baia.numero": "DESC" 
      })
      .getMany();
  }  

  async listByFazendaAndTipo(fazenda_id: number, tipoGranja_id: number) {
    return await baiaRepository.createQueryBuilder("baia")
      .leftJoinAndSelect("baia.ocupacao", "ocupacao")
      .leftJoinAndSelect("baia.granja", "granja")
      .leftJoinAndSelect("granja.tipoGranja", "tipoGranja")
      .leftJoinAndSelect("ocupacao.ocupacaoAnimais", "ocupacaoAnimais", "ocupacaoAnimais.status = :statusAtivo", { statusAtivo: StatusOcupacaoAnimal.ATIVO })
      .leftJoinAndSelect("ocupacaoAnimais.animal", "animal")
      .select([
        "baia.id", 
        "baia.numero", 
        "baia.vazia", 
        "ocupacao.id",
        "ocupacao.codigo",
        "ocupacaoAnimais.id",
        "animal.id",
        "animal.data_ultima_inseminacao",
        "animal.nascimento",
        "granja.id",
        "granja.descricao",
        "granja.codigo",
        "tipoGranja.id",
        "tipoGranja.descricao",
      ])
      .where("baia.fazenda_id = :fazenda_id AND baia.vazia = true", { fazenda_id })
      .andWhere("tipoGranja.id = :tipoGranja_id", { tipoGranja_id })
      .orderBy({ 
        "baia.vazia": "ASC", 
        "baia.numero": "DESC" 
      })
      .getMany();
  }  

  async delete(baia_id: number): Promise<void> {
    if (!baia_id) {
      throw new ValidationError('Parâmetros não informados');
    }

    await AppDataSource.transaction(async (transactionalEntityManager) => {
      await transactionalEntityManager.delete(Baia, baia_id);
    });
  }

  async getById(baia_id: number) {
    return await baiaRepository.findOne({ where: { id: baia_id } });
  }

  async listAllOcupacoes(granja_id: number) {
    return await baiaRepository.find({ 
      where: { 
        granja: { 
          id: Number(granja_id) 
        } 
      }, 
      relations: ['granja', 'fazenda', 'fazenda.cidade', 'fazenda.cidade.uf', 'ocupacoes']
    });
  }

  async validateBaia(baiaData: BaiaCreateOrUpdateData, baia?: Baia | null) {
    const fazenda = await ValidationService.validateAndReturnFazenda(baiaData.fazenda_id);

    if (!baiaData.numero || baiaData.numero.trim() === '') {
      throw new ValidationError('O número é obrigatório.');
    }

    if (baiaData.numero.length > 500) {
      throw new ValidationError('O número não pode ter mais de 500 caracteres.');
    }

    const granjaInstancia = await ValidationService.validateAndReturnGranja(baiaData.granja_id, fazenda);

    let createdBy: Usuario | null = null;
    let updatedBy: Usuario | null = null;

    if (baia) {
      updatedBy = await ValidationService.validateAndReturnUsuario(baiaData.usuarioIdAcao);
    } else {
      createdBy = await ValidationService.validateAndReturnUsuario(baiaData.usuarioIdAcao);
    }

    return {
      fazenda,
      granjaInstancia,
      createdBy,
      updatedBy,
    };
  }

}
