import { AppDataSource } from "../data-source";
import { animalRepository } from "../repositories/animalRepository";
import { Animal } from "../entities/Animal";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { Usuario } from "../entities/Usuario";
import { SexoAnimal, StatusAnimal } from "../constants/animalConstants";
import { Brackets, IsNull, Not } from "typeorm";
import { OcupacaoAnimal } from "../entities/OcupacaoAnimal";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";
import { OcupacaoService } from "./OcupacaoService";
import { isNull } from "util";
import { Nascimento } from "../entities/nascimento";
import { StatusOcupacao } from "../constants/ocupacaoConstants";

interface AnimalCreateOrUpdateData {
  numero_brinco: string;
  sexo: SexoAnimal;
  status: StatusAnimal;
  data_nascimento: Date;
  fazenda_id: number;
  usuarioIdAcao: number;
  nascimento?: boolean;
}

interface AnimalAdicionarNascimentoData {
  baia_id: number,
  matriz_id: number,
  quantidade: number,
  status: StatusAnimal;
  data_nascimento: Date;
  usuarioIdAcao: number;
  fazenda_id: number;
}

export class AnimalService {

  private ocupacaoService = new OcupacaoService(); 

  async list(fazenda_id: number) {
    return await animalRepository.find({ 
      where: { 
        fazenda: { id: fazenda_id },
        status: StatusAnimal.VIVO,
        numero_brinco: Not(IsNull()),
        nascimento: false,
      },
      select: ['id', 'numero_brinco'],
      order: { id: 'ASC' }
    });
  }

  async listDisponivelParaLote(fazenda_id: number) {
    const qb = animalRepository.createQueryBuilder('animal')
      .leftJoin('animal.loteAtual', 'loteAtual')
      .where('animal.fazenda.id = :fazenda_id', { fazenda_id })
      .andWhere('animal.status = :status', { status: StatusAnimal.VIVO })
      .andWhere('animal.sexo = :sexo', { sexo: SexoAnimal.FEMEA })
      .andWhere('animal.numero_brinco IS NOT NULL')
      .andWhere('animal.nascimento = false')
      .andWhere(new Brackets(qb => {
        qb.where('animal.loteAtual IS NULL')
          .orWhere('loteAtual.encerrado = true');
      }))
      .select(['animal.id', 'animal.numero_brinco'])
      .orderBy('animal.id', 'ASC');
  
    return await qb.getMany();
  }  

  async listNascimentos(ocupacao_id: number) {
    return await animalRepository.find({ 
      where: { 
        fazenda: { id: ocupacao_id },
        nascimento: true,
      },
      select: ['id', 'data_nascimento', 'status'],
      order: { id: 'ASC' }
    });
  }

  async listLiveAndDie(fazenda_id: number) {
    return await animalRepository.find({ 
      where: { 
        fazenda: { id: fazenda_id },
        numero_brinco: Not(IsNull()),
        nascimento: false,
      },
      select: ['id', 'numero_brinco'],
      order: { id: 'ASC' }
    });
  }

  async listPorcos(fazenda_id: number) {
    return await animalRepository.find({ 
      where: { 
        fazenda: { id: fazenda_id },
        status: StatusAnimal.VIVO,
        numero_brinco: Not(IsNull()),
        nascimento: false,
        sexo: SexoAnimal.MACHO,
      },
      select: ['id', 'numero_brinco'],
      order: { id: 'ASC' }
    });
  }

  async adicionarNascimento(adicionarNascimentoData: AnimalAdicionarNascimentoData){
    return await AppDataSource.transaction(async transactionalEntityManager => {

      // Validações comuns
      const usuario = await ValidationService.validateAndReturnUsuario(adicionarNascimentoData.usuarioIdAcao);
      const fazenda = await ValidationService.validateAndReturnFazenda(adicionarNascimentoData.fazenda_id);
      
      if (adicionarNascimentoData.quantidade < 1){
        throw new Error('Nenhum nascimento foi informado.');
      }

      const baiaDestino = await ValidationService.validateAndReturnBaia(adicionarNascimentoData.baia_id);

      //recupera a ocupacao da baia
      const ocupacao = await baiaDestino?.ocupacao;

      if (!ocupacao) {
        throw new ValidationError('Ocupação ativa não encontrada para o animal.');
      }

      //recupera a matriz (porca mae) para vincular no nascimento
      const matriz = await transactionalEntityManager.findOne(Animal, {
        where: { id: adicionarNascimentoData.matriz_id },
        relations: ['loteAtual', 'loteAnimalAtual'],
      });

      if (!matriz) {
        throw new ValidationError('Não foi possivel vincular o nascimento a matriz.');
      }

      if (!matriz.loteAtual || !matriz.loteAnimalAtual) {
        throw new ValidationError('A matriz informada não possui um lote vinculado.');
      }

      const resultados = [];
      const erros = [];

      for (let i = 0; i < adicionarNascimentoData.quantidade; i++) {
        try {

          const animal = transactionalEntityManager.create(Animal, {        
            fazenda: fazenda,
            status: adicionarNascimentoData.status,
            nascimento: true,
            data_nascimento: adicionarNascimentoData.data_nascimento,
            loteNascimento: matriz!.loteAtual!,
            loteAnimalNascimento: matriz!.loteAnimalAtual!,
            createdBy: usuario!,
          });

          await transactionalEntityManager.save(animal);

          const novaOcupacaoAnimal = transactionalEntityManager.create(OcupacaoAnimal, {
            ocupacao: { id: ocupacao.id }, // Ensure 'ocupacao' matches the expected type
            animal: { id: animal.id }, // Ensure 'animal' matches the expected type
            data_entrada: adicionarNascimentoData.data_nascimento,
            status: StatusOcupacaoAnimal.ATIVO,
            createdBy: usuario!,
          });

          await transactionalEntityManager.save(novaOcupacaoAnimal);

          const novoNascimento = transactionalEntityManager.create(Nascimento, {
            fazenda: fazenda,
            animal: { id: animal.id },
            matriz: { id: matriz.id },
            baia: { id: ocupacao.baia.id },
            data_nascimento: adicionarNascimentoData.data_nascimento,
            loteNascimento: matriz.loteAtual,
            loteAnimalNascimento: matriz.loteAnimalAtual,
          });

          await transactionalEntityManager.save(novoNascimento);

          matriz.data_ultima_cria = adicionarNascimentoData.data_nascimento;
          matriz.updatedBy = usuario!;
          await transactionalEntityManager.save(matriz);

          resultados.push({ 
            animal_id: animal.id,
            success: true,
            message: 'Nascimento registrado com sucesso'
          });

        } catch (error) {
          const message = error instanceof Error ? error.message : 'Erro ao registrar nascimento';          
          erros.push({
            message: message
          });
        }
      }

      if (erros.length > 0) {
        // Consolida todos os erros em uma única mensagem
        const errorMessage = erros.map(e => e.message).join('; ');
        throw new Error(errorMessage);
      }
  
      return {
        success: true,
        resultados,
        total: resultados.length,
        sucessos: resultados.length,
        falhas: erros.length
      };
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

  async deletarNascimento(animalId: number, usuarioIdAcao: number) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      let usuarioAcao = await ValidationService.validateAndReturnUsuario(usuarioIdAcao);

      const ocupacaoAtual = await transactionalEntityManager.findOne(OcupacaoAnimal, {
          where: { 
              animal: { id: animalId },
              status: StatusOcupacaoAnimal.ATIVO
          },
          relations: ['ocupacao', 'ocupacao.baia']
      });

      if (!ocupacaoAtual) return null;
  
      // Busca o animal com as ocupações
      const animal = await transactionalEntityManager.findOne(Animal, {
        where: { id: animalId }
      });
  
      if (!animal) {
        throw new Error(`Animal com ID ${animalId} não encontrado.`);
      }
  
      if (!animal.nascimento) {
        throw new Error(`Animal com ID ${animalId} não é um nascimento e não pode ser excluído por este método.`);
      }

      await transactionalEntityManager.delete(Nascimento, {
        animal: { id: animal.id }
      });
    
      // Remove as ocupações associadas ao animal
      await transactionalEntityManager.delete(OcupacaoAnimal, {
        animal: { id: animal.id }
      });
  
      // Remove o animal
      await transactionalEntityManager.delete(Animal, { id: animal.id });

      await this.ocupacaoService.verificaSeOcupacaoEstaVaziaEncerraSeSim(
        transactionalEntityManager,
        ocupacaoAtual.ocupacao.baia.id,
        ocupacaoAtual.ocupacao.id,
        usuarioAcao!.id,
      );

      return {
        success: true,
        message: 'Nascimento excluído com sucesso',
        animal_id: animal.id
      };
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

  async editarStatusNascimento(animalId: number, novoStatus: StatusAnimal, usuarioIdAcao: number) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      const usuario = await ValidationService.validateAndReturnUsuario(usuarioIdAcao);

      const ocupacaoAtual = await transactionalEntityManager.findOne(OcupacaoAnimal, {
        where: { 
          animal: { id: animalId },
          status: StatusOcupacaoAnimal.ATIVO
        },
        relations: ['ocupacao', 'ocupacao.baia']
      });

      if (!ocupacaoAtual) return null;
  
      const animal = await transactionalEntityManager.findOne(Animal, {
        where: { id: animalId }
      });
  
      if (!animal) {
        throw new ValidationError(`Animal com ID ${animalId} não encontrado.`);
      }
  
      if (!animal.nascimento) {
        throw new ValidationError(`Animal com ID ${animalId} não é um nascimento e não pode ter o status editado por este método.`);
      }
  
      if (!Object.values(StatusAnimal).includes(novoStatus)) {
        throw new ValidationError(`Status inválido para o animal.`);
      }
  
      animal.status = novoStatus;
      animal.updatedBy = usuario!;
  
      await transactionalEntityManager.save(animal);

      await this.ocupacaoService.verificaSeOcupacaoEstaVaziaEncerraSeSim(
        transactionalEntityManager,
        ocupacaoAtual.ocupacao.baia.id,
        ocupacaoAtual.ocupacao.id,
        usuarioIdAcao
      );
  
      return {
        success: true,
        message: 'Status do nascimento atualizado com sucesso',
        animal_id: animal.id,
        novo_status: novoStatus
      };
    });
  }
  
}
