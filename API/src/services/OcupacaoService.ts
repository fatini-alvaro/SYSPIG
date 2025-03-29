import { AppDataSource } from "../data-source";
import { ocupacaoRepository } from "../repositories/ocupacaoRepository";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { OcupacaoAnimal } from "../entities/OcupacaoAnimal";
import { Animal } from "../entities/Animal";
import { Ocupacao } from "../entities/Ocupacao";
import { Usuario } from "../entities/Usuario";
import { StatusOcupacao } from "../constants/ocupacaoConstants";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";

interface OcupacaoCreateOrUpdateData {
  fazenda_id: number;
  baia_id: number;
  status: number;
  ocupacao_animais: { animal_id: number }[];
  usuarioIdAcao: number;
}

interface AddAnimalToOcupacaoData {
  ocupacao_id: number;
  animal_id: number;
  usuarioIdAcao: number;
}

export class OcupacaoService {

  async list(fazenda_id: number) {
    return await ocupacaoRepository.find({
      relations: ['baia'],
      where: {
        fazenda: {
          id: Number(fazenda_id),
        },
      },
      select: ["id", "codigo"],
      order: { id: "DESC" },
    });
  }

  async getById(ocupacao_id: number) {
    return await ocupacaoRepository.findOne({
      where: { id: ocupacao_id },
      relations: ['ocupacaoAnimais'],
    });
  }

  async getByBaiaId(baia_id: number) {
    return await ocupacaoRepository.findOne({ 
      where: { 
        baia: { 
          id: Number(baia_id) 
        },
        status: StatusOcupacao.ABERTA
      },
      relations: [
        'baia',
        'anotacoes',
        'ocupacaoAnimais',
        'ocupacaoAnimais.animal'
      ],
      order: { id: 'DESC' }
    });
  }

  async createOrUpdate(ocupacaoData: OcupacaoCreateOrUpdateData, ocupacao_id?: number) {
    return await AppDataSource.transaction(async (transactionalEntityManager) => {
      let ocupacao: Ocupacao | null = null;

      if (ocupacao_id) {
        ocupacao = await ValidationService.validateAndReturnOcupacao(ocupacao_id);
      }

      const { fazenda, 
        baiaInstancia,
        createdBy,
        updatedBy, } = await this.validateOcupacao(
        ocupacaoData,
        ocupacao
      );

      if (!ocupacao) {
        ocupacao = transactionalEntityManager.create(Ocupacao, { fazenda });
      }

      ocupacao.baia = baiaInstancia!;
      ocupacao.status = ocupacaoData.status;
      ocupacao.data_abertura = ocupacao.data_abertura ?? new Date();
      ocupacao.createdBy = createdBy ?? ocupacao.createdBy;
      ocupacao.updatedBy = updatedBy ?? ocupacao.updatedBy;
      await transactionalEntityManager.save(ocupacao);

      // Gerenciar associações de ocupacaoAnimais
      const existingOcupacaoAnimais = await transactionalEntityManager.find(OcupacaoAnimal, {
        where: { ocupacao: { id: ocupacao.id } },
      });
      const existingAnimalIds = existingOcupacaoAnimais.map((la) => la.animal.id);
      const newAnimalIds = ocupacaoData.ocupacao_animais.map((la) => la.animal_id);

      // Animais a serem removidos
      const animalsToRemove = existingOcupacaoAnimais.filter((la) => !newAnimalIds.includes(la.animal.id));
      if (animalsToRemove.length > 0) {
        await transactionalEntityManager.remove(OcupacaoAnimal, animalsToRemove);
      }

      // Animais a serem adicionados
      const animalsToAdd = ocupacaoData.ocupacao_animais.filter((la) => !existingAnimalIds.includes(la.animal_id));
      for (const ocupacaoAnimalData of animalsToAdd) {
        const animal = await transactionalEntityManager.findOneBy(Animal, { id: Number(ocupacaoAnimalData.animal_id) });
        if (animal) {
          const newOcupacaoAnimal = new OcupacaoAnimal();
          newOcupacaoAnimal.ocupacao = ocupacao;
          newOcupacaoAnimal.animal = animal;
          newOcupacaoAnimal.createdBy = createdBy ?? ocupacao.createdBy;
          await transactionalEntityManager.save(newOcupacaoAnimal);
        }
      }

      baiaInstancia!.ocupacao = ocupacao;
      baiaInstancia!.vazia = false;
      
      await transactionalEntityManager.save(baiaInstancia);

      return ocupacao;
    });
  }

  async validateOcupacao(ocupacaoData: OcupacaoCreateOrUpdateData, ocupacao?: Ocupacao | null) {
    const fazenda = await ValidationService.validateAndReturnFazenda(
      ocupacaoData.fazenda_id
    );

    if (!Object.values(StatusOcupacao).includes(ocupacaoData.status as StatusOcupacao)) {
      throw new ValidationError('O status da ocupação não foi informado.');
    }

    const baiaInstancia = await ValidationService.validateAndReturnBaia(ocupacaoData.baia_id, fazenda);

    if (!ocupacaoData.ocupacao_animais || ocupacaoData.ocupacao_animais.length === 0) {
      throw new ValidationError('A ocupação deve ter pelo menos um animal.');
    }

    let createdBy: Usuario | null = null;
    let updatedBy: Usuario | null = null;

    if (ocupacao) {
      updatedBy = await ValidationService.validateAndReturnUsuario(ocupacaoData.usuarioIdAcao);
    } else {
      createdBy = await ValidationService.validateAndReturnUsuario(ocupacaoData.usuarioIdAcao);
    }

    return {
      fazenda,
      baiaInstancia,
      createdBy,
      updatedBy,
    };
  }

  async addAnimalToOcupacao(data: AddAnimalToOcupacaoData) {
    return await AppDataSource.transaction(async (transactionalEntityManager) => {
      const ocupacao = await ValidationService.validateAndReturnOcupacao(data.ocupacao_id);
      const animal = await ValidationService.validateAndReturnAnimal(data.animal_id);
      const usuario = await ValidationService.validateAndReturnUsuario(data.usuarioIdAcao);

      if (!ocupacao || !animal || !usuario) {
        throw new ValidationError('Ocupação, animal ou usuário não encontrado.');
      }

      // Verifica se o animal já está na ocupação
      const existingOcupacaoAnimal = await transactionalEntityManager.findOne(OcupacaoAnimal, {
        where: {
          ocupacao: { id: ocupacao.id },
          animal: { id: animal.id },
          status: StatusOcupacaoAnimal.ATIVO
        }
      });

      if (existingOcupacaoAnimal) {
        throw new ValidationError('O animal já está nesta ocupação.');
      }

      const novaOcupacaoAnimal = new OcupacaoAnimal();
      novaOcupacaoAnimal.ocupacao = ocupacao;
      novaOcupacaoAnimal.animal = animal;
      novaOcupacaoAnimal.data_entrada = new Date();
      novaOcupacaoAnimal.status = StatusOcupacaoAnimal.ATIVO;
      novaOcupacaoAnimal.createdBy = usuario;

      await transactionalEntityManager.save(novaOcupacaoAnimal);

      return await this.getById(ocupacao.id);
    });
  }
}
