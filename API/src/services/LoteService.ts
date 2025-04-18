import { AppDataSource } from "../data-source";
import { Lote } from "../entities/Lote";
import { loteRepository } from "../repositories/loteRepository";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { LoteAnimal } from "../entities/LoteAnimal";
import { Animal } from "../entities/Animal";

interface LoteCreateOrUpdateData {
  descricao: string;
  numero_lote: string;
  data: Date;
  lote_animais: { animal_id: number }[]; // Agora apenas o ID do animal
  fazenda_id: number;
  usuarioIdAcao: number;
}

export class LoteService {

  async list(fazenda_id: number) {
    return await loteRepository.find({
      where: {
        fazenda: {
          id: Number(fazenda_id),
        },
      },
      select: ["id", "descricao", "numero_lote"],
      order: { id: "DESC" },
    });
  }

  async listAtivo(fazenda_id: number) {
    return await loteRepository.find({
      where: {
        fazenda: {
          id: Number(fazenda_id),
        },
        encerrado: false,
      },
      relations: ['loteAnimais'],
      order: { id: "DESC" },
    });
  }

  async createOrUpdate(loteData: LoteCreateOrUpdateData, lote_id?: number) {
    return await AppDataSource.transaction(async (transactionalEntityManager) => {
      let lote: Lote | null = null;

      if (lote_id) {
        lote = await ValidationService.validateAndReturnLote(lote_id);
      }

      const { fazenda, createdBy, updatedBy } = await this.validateLote(
        loteData,
        lote
      );

      if (!lote) {
        lote = transactionalEntityManager.create(Lote, { fazenda });
      }

      lote.descricao = loteData.descricao;
      lote.numero_lote = loteData.numero_lote;
      lote.data = loteData.data;
      lote.createdBy = createdBy ?? lote.createdBy;
      lote.updatedBy = updatedBy ?? lote.updatedBy;
      await transactionalEntityManager.save(lote);

      // Gerenciar associações de LoteAnimal
      const existingLoteAnimais = await transactionalEntityManager.find(LoteAnimal, {
        where: { lote: { id: lote.id } },
      });
      const existingAnimalIds = existingLoteAnimais.map((la) => la.animal.id);
      const newAnimalIds = loteData.lote_animais.map((la) => la.animal_id);

      // Animais a serem removidos
      // Animais a serem removidos
      const animalsToRemove = existingLoteAnimais.filter((la) => !newAnimalIds.includes(la.animal.id));
      if (animalsToRemove.length > 0) {
        for (const loteAnimal of animalsToRemove) {
          // Remove o vínculo do lote no próprio animal
          await transactionalEntityManager.update(
            Animal,
            { id: loteAnimal.animal.id },
            {
              loteAtual: null,
              updated_at: new Date()
            }
          );
        }

        // Remove a associação LoteAnimal
        await transactionalEntityManager.remove(LoteAnimal, animalsToRemove);
      }

      // Animais a serem adicionados
      const animalsToAdd = loteData.lote_animais.filter((la) => !existingAnimalIds.includes(la.animal_id));
      for (const loteAnimalData of animalsToAdd) {
        const animal = await transactionalEntityManager.findOneBy(Animal, { id: Number(loteAnimalData.animal_id) });
        if (animal) {
          const newLoteAnimal = new LoteAnimal();
          newLoteAnimal.lote = lote;
          newLoteAnimal.animal = animal;
          newLoteAnimal.createdBy = createdBy ?? lote.createdBy;
          await transactionalEntityManager.save(newLoteAnimal);

          await transactionalEntityManager.update(
            Animal,
            { id: animal.id },
            { 
              loteAtual: { id: lote.id },
              updated_at: new Date()
            }
          );
        }
      }

      return lote;
    });
  }

  async delete(lote_id: number): Promise<void> {
    if (!lote_id) {
      throw new ValidationError("Parâmetros não informados");
    }
  
    await AppDataSource.transaction(async (transactionalEntityManager) => {
      // Buscar todos os animais associados ao lote
      const loteAnimais = await transactionalEntityManager.find(LoteAnimal, {
        where: { lote: { id: lote_id } },
        relations: ['animal'],
      });
  
      // Limpar o campo loteAtual de cada animal associado
      for (const loteAnimal of loteAnimais) {
        await transactionalEntityManager.update(
          Animal,
          { id: loteAnimal.animal.id },
          {
            loteAtual: null,
            updated_at: new Date()
          }
        );
      }
  
      // Deletar registros de lote_animal relacionados ao lote
      await transactionalEntityManager.delete(LoteAnimal, { lote: { id: lote_id } });
  
      // Agora, deletar o lote
      await transactionalEntityManager.delete(Lote, { id: lote_id });
    });
  }
  

  async getById(lote_id: number) {
    return await loteRepository.findOne({
      where: { id: lote_id },
      relations: ['loteAnimais'],
    });
  }  

  async validateLote(loteData: LoteCreateOrUpdateData, lote?: Lote | null) {
    const fazenda = await ValidationService.validateAndReturnFazenda(
      loteData.fazenda_id
    );

    if (!loteData.descricao || loteData.descricao.trim() === "") {
      throw new ValidationError("A descrição é obrigatória.");
    }

    if (loteData.descricao.length > 500) {
      throw new ValidationError("A descrição não pode ter mais de 500 caracteres.");
    }

    if (!loteData.numero_lote || loteData.numero_lote.trim() === "") {
      throw new ValidationError("O número do lote é obrigatório.");
    }

    if (loteData.descricao.length > 500) {
      throw new ValidationError("O número não pode ter mais de 500 caracteres.");
    }

    const loteExistente = await loteRepository.findOne({
      where: {
        numero_lote: loteData.numero_lote,
        fazenda: { id: loteData.fazenda_id } 
      }
    });

    if (loteExistente && (!lote || loteExistente.id !== lote.id)) {
      throw new ValidationError('Já existe um lote com esse número nesta fazenda.');
    }

    let createdBy = null;
    let updatedBy = null;

    if (lote) {
      updatedBy = await ValidationService.validateAndReturnUsuario(
        loteData.usuarioIdAcao
      );
    } else {
      createdBy = await ValidationService.validateAndReturnUsuario(
        loteData.usuarioIdAcao
      );
    }

    return {
      fazenda,
      createdBy,
      updatedBy,
    };
  }
}
