import { AppDataSource } from "../data-source";
import { animalRepository } from "../repositories/animalRepository";
import { Animal } from "../entities/Animal";
import { Fazenda } from "../entities/Fazenda";

interface AnimalCreateOrUpdateData {
  numeroBrinco: string;
  sexo: string;
  status: number;
  dataNascimento: Date;
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

  async createOrUpdate(fazenda_id: number, animalData: AnimalCreateOrUpdateData, animal_id?: number) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      let animal;

      if (animal_id) {
        // Atualiza o animal existente
        animal = await transactionalEntityManager.findOne(Animal, { where: { id: animal_id } });
        if (!animal) {
        throw new Error('Animal não encontrado');
        }
        animal.numero_brinco = animalData.numeroBrinco;
        animal.sexo = animalData.sexo;
        animal.status = animalData.status;
        animal.data_nascimento = animalData.dataNascimento;
      } else {
        // Cria um novo animal
        const fazenda = await transactionalEntityManager.findOne(Fazenda, { where: { id: fazenda_id } });
        if (!fazenda) {
        throw new Error('Fazenda não encontrada');
        }

        animal = transactionalEntityManager.create(Animal, {
        fazenda,
        numero_brinco: animalData.numeroBrinco,
        sexo: animalData.sexo,
        data_nascimento: animalData.dataNascimento,
        status: animalData.status
        });
      }

      await transactionalEntityManager.save(animal);

      return animal;
    });
  }

  async deleteAnimal(animal_id: number): Promise<void> {
    if (!animal_id) {
      throw new Error('Parâmetros não informados');
    }

    await AppDataSource.transaction(async (transactionalEntityManager) => {
      await transactionalEntityManager.delete(Animal, animal_id);
    });
  }

}
