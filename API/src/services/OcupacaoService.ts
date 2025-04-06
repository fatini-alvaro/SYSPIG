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
import { Baia } from "../entities/Baia";
import { EntityManager, In } from "typeorm";
import { classToPlain } from "class-transformer";
import { Fazenda } from "../entities/Fazenda";
import { Movimentacao } from "../entities/movimentacao";
import { StatusMovimentacao, TipoMovimentacao } from "../constants/movimentacaoConstants";

interface OcupacaoCreateOrUpdateData {
  fazenda_id: number;
  baia_id: number;
  status: number;
  ocupacao_animais: { animal_id: number }[];
  usuarioIdAcao: number;
}

interface MovimentacaoData {
  animal_id: number;
  baia_destino_id: number;
}

interface MovimentarAnimaisData {
  fazenda_id: number;
  movimentacoes: MovimentacaoData[];
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
    return await ocupacaoRepository
      .createQueryBuilder("ocupacao")
      .leftJoinAndSelect("ocupacao.ocupacaoAnimais", "ocupacaoAnimais", "ocupacaoAnimais.status = :status", { status: StatusOcupacaoAnimal.ATIVO })
      .leftJoinAndSelect("ocupacaoAnimais.animal", "animal")
      .leftJoinAndSelect("ocupacao.baia", "baia")
      .leftJoinAndSelect("ocupacao.anotacoes", "anotacoes")
      .where("ocupacao.id = :id", { id: ocupacao_id })
      .getOne();
  }

  async getByBaiaId(baia_id: number) {
    return await ocupacaoRepository
      .createQueryBuilder("ocupacao")
      .leftJoinAndSelect("ocupacao.baia", "baia")
      .leftJoinAndSelect("ocupacao.anotacoes", "anotacoes")
      .leftJoinAndSelect("ocupacao.ocupacaoAnimais", "ocupacaoAnimais")
      .leftJoinAndSelect("ocupacaoAnimais.animal", "animal")
      .where("ocupacao.baia.id = :baia_id", { baia_id: Number(baia_id) })
      .andWhere("ocupacao.status = :status", { status: StatusOcupacao.ABERTA })
      .andWhere("ocupacaoAnimais.status = :animalStatus", { animalStatus: StatusOcupacaoAnimal.ATIVO })
      .orderBy("ocupacao.id", "DESC")
      .getOne();
  }

  async createOrUpdate(ocupacaoData: OcupacaoCreateOrUpdateData, ocupacao_id?: number) {
    return await AppDataSource.transaction(async (transactionalEntityManager) => {
      let ocupacao: Ocupacao | null = null;

      if (ocupacao_id) {
        ocupacao = await ValidationService.validateAndReturnOcupacao(ocupacao_id);
      }

      const { fazenda, baiaInstancia, createdBy, updatedBy } = 
        await this.validateOcupacao(ocupacaoData, ocupacao);

      if (!ocupacao) {
        ocupacao = transactionalEntityManager.create(Ocupacao, { fazenda });
      }

      ocupacao.baia = baiaInstancia!;
      ocupacao.status = ocupacaoData.status;
      ocupacao.data_abertura = ocupacao.data_abertura ?? new Date();
      ocupacao.createdBy = createdBy ?? ocupacao.createdBy;
      ocupacao.updatedBy = updatedBy ?? ocupacao.updatedBy;
      await transactionalEntityManager.save(ocupacao);

      await this.processarOcupacaoAnimais(
        transactionalEntityManager,
        ocupacao,
        ocupacaoData.ocupacao_animais,
        createdBy ?? ocupacao.createdBy
      );

      const animalIds = ocupacaoData.ocupacao_animais.map(({ animal_id }) => animal_id);

      // Busca os animais no banco
      const animais = await transactionalEntityManager.find(Animal, {
        where: { id: In(animalIds) }, // Filtra pelos IDs recebidos
      });

      // Mapeia os animais encontrados para um objeto de busca rápida
      const animaisMap = new Map(animais.map(animal => [animal.id, animal]));

      for (const { animal_id } of ocupacaoData.ocupacao_animais) {
        const animal = animaisMap.get(animal_id);
        
        if (!animal) {
          console.warn(`Animal com ID ${animal_id} não encontrado.`);
          continue;
        }
      
        await this.registrarMovimentacao(
          transactionalEntityManager,
          animal,
          null,
          ocupacao.baia,
          createdBy ?? ocupacao.createdBy
        );
      }

      baiaInstancia!.ocupacao = ocupacao;
      baiaInstancia!.vazia = false;
      await transactionalEntityManager.save(baiaInstancia);

      return ocupacao;
    });
  }

  private async processarOcupacaoAnimais(
    manager: EntityManager,
    ocupacao: Ocupacao,
    ocupacaoAnimais: { animal_id: number }[],
    usuario: Usuario
  ) {
    const existingOcupacaoAnimais = await manager.find(OcupacaoAnimal, {
      where: { ocupacao: { id: ocupacao.id } },
    });
    
    const existingAnimalIds = existingOcupacaoAnimais.map(oa => oa.animal.id);
    const newAnimalIds = ocupacaoAnimais.map(oa => oa.animal_id);

    // Remover animais não mais presentes
    const toRemove = existingOcupacaoAnimais.filter(oa => !newAnimalIds.includes(oa.animal.id));
    if (toRemove.length > 0) {
      await manager.remove(OcupacaoAnimal, toRemove);
    }

    // Adicionar novos animais
    const toAdd = ocupacaoAnimais.filter(oa => !existingAnimalIds.includes(oa.animal_id));
    for (const oaData of toAdd) {
      const animal = await manager.findOneBy(Animal, { id: Number(oaData.animal_id) });
      if (animal) {
        const newOcupacaoAnimal = manager.create(OcupacaoAnimal, {
          ocupacao,
          animal,
          createdBy: usuario
        });
        await manager.save(newOcupacaoAnimal);
      }
    }
  }

  async validateOcupacao(ocupacaoData: OcupacaoCreateOrUpdateData, ocupacao?: Ocupacao | null) {
    const fazenda = await ValidationService.validateAndReturnFazenda(ocupacaoData.fazenda_id);

    if (!Object.values(StatusOcupacao).includes(ocupacaoData.status as StatusOcupacao)) {
      throw new ValidationError('Status da ocupação inválido');
    }

    const baiaInstancia = await ValidationService.validateAndReturnBaia(ocupacaoData.baia_id, fazenda);

    if (!ocupacaoData.ocupacao_animais || ocupacaoData.ocupacao_animais.length === 0) {
      throw new ValidationError('A ocupação deve ter pelo menos um animal');
    }

    let createdBy: Usuario | null = null;
    let updatedBy: Usuario | null = null;

    if (ocupacao) {
      updatedBy = await ValidationService.validateAndReturnUsuario(ocupacaoData.usuarioIdAcao);
    } else {
      createdBy = await ValidationService.validateAndReturnUsuario(ocupacaoData.usuarioIdAcao);
    }

    return { fazenda, baiaInstancia, createdBy, updatedBy };
  }

  async movimentarAnimais(data: MovimentarAnimaisData) {
    return await AppDataSource.transaction(async (transactionalEntityManager) => {
      const { fazenda_id, movimentacoes, usuarioIdAcao } = data;
      
      // Validações comuns
      const usuario = await ValidationService.validateAndReturnUsuario(usuarioIdAcao);
      const fazenda = await ValidationService.validateAndReturnFazenda(fazenda_id);
  
      // Validação inicial da lista
      if (!movimentacoes || movimentacoes.length === 0) {
        throw new Error('Nenhuma movimentação foi informada');
      }
  
      const resultados = [];
      const erros = [];
  
      for (const movimentacao of movimentacoes) {
        try {
          const { animal_id, baia_destino_id } = movimentacao;
          
          // Validações específicas para cada movimentação
          const animal = await ValidationService.validateAndReturnAnimal(animal_id);
          const baiaDestino = await ValidationService.validateAndReturnBaia(baia_destino_id);
  
          // Verificar se o animal já está na baia de destino
          const ocupacaoAtiva = await transactionalEntityManager.findOne(OcupacaoAnimal, {
            where: { 
              animal: { id: animal!.id },
              ocupacao: { baia: { id: baiaDestino!.id } },
              status: StatusOcupacaoAnimal.ATIVO
            }
          });
  
          if (ocupacaoAtiva) {
            throw new Error(`O animal ${animal_id} já está na baia de destino ${baia_destino_id}`);
          }
  
          // Processar ocupação atual do animal
          const ocupacaoAtual = await this.tratarOcupacaoAtual(
            transactionalEntityManager, 
            animal!.id, 
            usuario!
          );
  
          // Processar baia de destino
          const ocupacaoDestino = await this.processarBaiaDestino(
            transactionalEntityManager,
            fazenda,
            baiaDestino!.id,
            usuario!
          );
  
          // Criar nova associação
          await this.criarNovaOcupacaoAnimal(
            transactionalEntityManager,
            ocupacaoDestino,
            animal!,
            usuario!
          );
  
          // Registrar movimentação
          await this.registrarMovimentacao(
            transactionalEntityManager,
            animal!,
            ocupacaoAtual?.ocupacao?.baia,
            baiaDestino!,
            usuario!
          );
  
          resultados.push({ 
            animal_id: animal!.id,
            success: true,
            message: 'Animal movimentado com sucesso'
          });
        } catch (error) {
          const message = error instanceof Error ? error.message : 'Erro ao movimentar animal';
          
          erros.push({ 
            animal_id: movimentacao.animal_id,
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
        total: movimentacoes.length,
        sucessos: resultados.length,
        falhas: erros.length
      };
    });
  }

  private async tratarOcupacaoAtual(
      manager: EntityManager,
      animalId: number,
      usuario: Usuario
  ): Promise<OcupacaoAnimal | null> {
    const ocupacaoAtual = await manager.findOne(OcupacaoAnimal, {
        where: { 
            animal: { id: animalId },
            status: StatusOcupacaoAnimal.ATIVO
        },
        relations: ['ocupacao', 'ocupacao.baia']
    });

    if (!ocupacaoAtual) return null;

    // Atualizar ocupação atual do animal
    ocupacaoAtual.data_saida = new Date();
    ocupacaoAtual.status = StatusOcupacaoAnimal.REMOVIDO;
    ocupacaoAtual.updatedBy = usuario;
    await manager.save(ocupacaoAtual);

    // Verificar se a baia de origem ficou vazia
    const animaisAtivos = await manager.count(OcupacaoAnimal, {
        where: { 
            ocupacao: { id: ocupacaoAtual.ocupacao.id },
            status: StatusOcupacaoAnimal.ATIVO
        }
    });

    if (animaisAtivos === 0) {
        // Atualizar a ocupação
        ocupacaoAtual.ocupacao.status = StatusOcupacao.FINALIZADA;
        await manager.save(ocupacaoAtual.ocupacao);

        // Atualizar a baia - remover vínculo e marcar como vazia
        const baia = ocupacaoAtual.ocupacao.baia;
        baia.vazia = true;
        baia.ocupacao = null; // Remove o vínculo com a ocupação
        await manager.save(baia);
    }

    return ocupacaoAtual;
  }

  private async processarBaiaDestino(
    manager: EntityManager,
    fazenda: Fazenda,
    baiaDestinoId: number,
    usuario: Usuario
  ): Promise<Ocupacao> {
    let ocupacaoDestino = await manager.findOne(Ocupacao, {
      where: { 
        baia: { id: baiaDestinoId },
        status: StatusOcupacao.ABERTA
      },
      relations: ['baia']
    });

    if (!ocupacaoDestino) {
      // Criar nova ocupação seguindo o mesmo padrão do createOrUpdate
      ocupacaoDestino = manager.create(Ocupacao, {
        fazenda,
        baia: { id: baiaDestinoId },
        status: StatusOcupacao.ABERTA,
        data_abertura: new Date(),
        createdBy: usuario
      });
      
      ocupacaoDestino = await manager.save(ocupacaoDestino);
      
      // Atualizar status da baia
      await manager.update(Baia, baiaDestinoId, { 
        vazia: false,
        ocupacao: ocupacaoDestino
      });
    }

    return ocupacaoDestino;
  }

  private async criarNovaOcupacaoAnimal(
    manager: EntityManager,
    ocupacao: Ocupacao,
    animal: Animal,
    usuario: Usuario
  ): Promise<OcupacaoAnimal> {
    const novaOcupacaoAnimal = manager.create(OcupacaoAnimal, {
      ocupacao,
      animal,
      data_entrada: new Date(),
      status: StatusOcupacaoAnimal.ATIVO,
      createdBy: usuario
    });

    return await manager.save(novaOcupacaoAnimal);
  }

  private async registrarMovimentacao(
    manager: EntityManager,
    animal: Animal,
    baiaOrigem: Baia | null | undefined,
    baiaDestino: Baia,
    usuario: Usuario
  ): Promise<Movimentacao> {

    await manager.update(
      Movimentacao,
      { 
        animal: { id: animal.id },
        status: StatusMovimentacao.ATIVA 
      },
      { 
        status: StatusMovimentacao.HISTORICO,
        updated_at: new Date()
      }
    );

    let tipo: TipoMovimentacao;
    let observacoes: string;

    if (!baiaOrigem) {
        tipo = TipoMovimentacao.ENTRADA;
        observacoes = `Animal alocado na baia ${baiaDestino.codigo}`;
    } else if (baiaDestino) {
        tipo = TipoMovimentacao.TRANSFERENCIA;
        observacoes = `Animal transferido da baia ${baiaOrigem.codigo} para ${baiaDestino.codigo}`;
    } else {
        tipo = TipoMovimentacao.SAIDA;
        observacoes = `Animal removido do sistema (baia ${baiaOrigem.codigo})`;
    }

    const movimentacao = manager.create(Movimentacao, {
        animal,
        baiaOrigem: baiaOrigem || null,
        baiaDestino,
        dataMovimentacao: new Date(),
        tipo,
        status: StatusMovimentacao.ATIVA,
        usuario,
        observacoes
    });

    return await manager.save(movimentacao);
  }
}