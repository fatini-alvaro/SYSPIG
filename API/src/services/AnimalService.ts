import { AppDataSource } from "../data-source";
import { animalRepository } from "../repositories/animalRepository";
import { Animal } from "../entities/Animal";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { Usuario } from "../entities/Usuario";
import { SexoAnimal, StatusAnimal } from "../constants/animalConstants";

interface AnimalCreateOrUpdateData {
  numero_brinco: string;
  sexo: SexoAnimal;
  status: StatusAnimal;
  data_nascimento: Date;
  fazenda_id: number;
  usuarioIdAcao: number;
}

export class AnimalService {

  async list(fazenda_id: number) {
    return await animalRepository.find({ 
      where: { 
        fazenda: { id: fazenda_id }
      },
      select: ['id', 'numero_brinco'],
      order: { id: 'ASC' }
    });
  }
  
  async getById(animal_id: number) {
    // Buscar o animal
    const animal = await animalRepository.findOne({
      where: { id: animal_id },
    });
  
    if (animal) {
      // Buscar a ocupação ativa do animal usando o método getOcupacaoAtiva
      const ocupacao_animal_ativa = await animal.getOcupacaoAtiva();
  
      // Incluir a ocupação ativa na resposta, mas não como um campo no banco, apenas na resposta
      return { ...animal, ocupacao_animal_ativa };
    }
  
    // Se o animal não for encontrado, retornar null ou um erro
    return null;
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

  async delete(animal_id: number): Promise<void> {
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

    const animalExistente = await animalRepository.findOne({
      where: {
        numero_brinco: animalData.numero_brinco,
        fazenda: { id: animalData.fazenda_id } 
      }
    });

    if (animalExistente && (!animal || animalExistente.id !== animal.id)) {
      throw new ValidationError('Já existe um animal com esse número de brinco nesta fazenda.');
    }

    if (!Object.values(SexoAnimal).includes(animalData.sexo as SexoAnimal)) {
      throw new ValidationError('O sexo do animal deve ser M ou F.');
    }

    if (!Object.values(StatusAnimal).includes(animalData.status as StatusAnimal)) {
      throw new ValidationError('O status do animal deve ser Vivo, Morto ou Vendido.');
    }

    let createdBy: Usuario | null = null;
    let updatedBy: Usuario | null = null;

    if (animal) {
      updatedBy = await ValidationService.validateAndReturnUsuario(animalData.usuarioIdAcao);
    } else {
      createdBy = await ValidationService.validateAndReturnUsuario(animalData.usuarioIdAcao);
    }

    return {
      fazenda,
      createdBy,
      updatedBy,
    };
  }
}
