import { AppDataSource } from "../data-source";
import { animalRepository } from "../repositories/animalRepository";
import { Animal } from "../entities/Animal";
import { Fazenda } from "../entities/Fazenda";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { Usuario } from "../entities/Usuario";

interface AnimalCreateOrUpdateData {
  numero_brinco: string;
  sexo: string;
  status: number;
  data_nascimento: Date;
  fazenda_id: number;
}

export class AnimalService {

  async list(fazenda_id: number) {
    return await animalRepository.find({ 
      where: { 
        fazenda: { id: fazenda_id }
      },
      select: ['id', 'numero_brinco'],
    });
  }
  
  async getById(animal_id: number) {
    return await animalRepository.findOne({ where: { id: animal_id } });
  }

  async createOrUpdate(animalData: AnimalCreateOrUpdateData, animal_id?: number) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      let animal: Animal | null = null;

      if (animal_id) {
        animal = await ValidationService.validateAndReturnAnimal(animal_id);
      }

      const { fazenda, createdBy, updatedBy } =
        await this.validateAnimal(animalData, animal);

      if (!animal) {
        animal = transactionalEntityManager.create(Animal, { fazenda });
      }

      animal.numero_brinco = animalData.numero_brinco;
      animal.sexo = animalData.sexo;
      animal.status = animalData.status;
      animal.data_nascimento = animalData.data_nascimento;
      animal.createdBy = createdBy ?? animal.createdBy;
      animal.updatedBy = updatedBy ?? animal.updatedBy;

      await transactionalEntityManager.save(animal);
      return animal;
    });
  }

  async deleteAnimal(animal_id: number): Promise<void> {
    if (!animal_id) {
      throw new ValidationError('Parâmetros não informados');
    }

    await AppDataSource.transaction(async (transactionalEntityManager) => {
      await transactionalEntityManager.delete(Animal, animal_id);
    });
  }

  async validateAnimal(animalData: AnimalCreateOrUpdateData, animal?: Animal | null) {
    const fazenda = await ValidationService.validateAndReturnFazenda(animalData.fazenda_id);

    if (!animalData.numero_brinco || animalData.numero_brinco.trim() === '') {
      throw new ValidationError('O número do brinco é obrigatório.');
    }

    if (animalData.numero_brinco.length > 500) {
      throw new ValidationError('O número do brinco não pode ter mais de 500 caracteres.');
    }

    if (animalData.sexo !== 'M' && animalData.sexo !== 'F') {
      throw new ValidationError('O sexo do animal deve ser M ou F.');
    }

    if (animalData.status < 0 || animalData.status > 2) {
      throw new ValidationError('O status do animal deve ser Vivo, Morto ou Vendido.');
    }

    let createdBy: Usuario | null = null;
    let updatedBy: Usuario | null = null;

    return {
      fazenda,
      createdBy,
      updatedBy,
    };
  }
}
