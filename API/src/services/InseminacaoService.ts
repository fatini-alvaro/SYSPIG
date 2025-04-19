import { AppDataSource } from "../data-source";
import { animalRepository } from "../repositories/animalRepository";
import { Animal } from "../entities/Animal";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { Usuario } from "../entities/Usuario";
import { SexoAnimal, StatusAnimal } from "../constants/animalConstants";
import { EntityManager, IsNull, Not } from "typeorm";
import { OcupacaoAnimal } from "../entities/OcupacaoAnimal";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";
import { OcupacaoService } from "./OcupacaoService";
import { Inseminacao } from "../entities/Inseminacao";
import { Fazenda } from "../entities/Fazenda";
import { LoteAnimal } from "../entities/LoteAnimal";
import { Lote } from "../entities/Lote";

interface InseminacaoData {
  porca_inseminada_id: number;
  porco_doador_id: number;
  lote_animal_id: number;
  baia_id: number;
  data: Date;
}

interface InseminacoesData {
  fazenda_id: number;
  usuarioIdAcao: number;
  inseminacoes: InseminacaoData[];
}

export class InseminacaoService {

  private ocupacaoService = new OcupacaoService(); 

  async list(fazenda_id: number) {

  }

  async inseminarAnimais(data: InseminacoesData) {
    return await AppDataSource.transaction(async (transactionalEntityManager) => {
      const { fazenda_id, inseminacoes, usuarioIdAcao } = data;

      const usuario = await ValidationService.validateAndReturnUsuario(usuarioIdAcao);
      const fazenda = await ValidationService.validateAndReturnFazenda(fazenda_id);

      if (!inseminacoes || inseminacoes.length === 0) {
        throw new Error('Nenhuma inseminação foi informada');
      }

      const resultados = [];
      const erros = [];

      for (const inseminacao of inseminacoes) {
        try {

          const { porca_inseminada_id, porco_doador_id, baia_id } = inseminacao;

          const matriz = await ValidationService.validateAndReturnAnimal(porca_inseminada_id);
          const porcoDoador = await ValidationService.validateAndReturnAnimal(porco_doador_id);
          const baiaInseminacao = await ValidationService.validateAndReturnBaia(baia_id);

          const ocupacaoAtiva = await transactionalEntityManager.findOne(OcupacaoAnimal, {
            where: { 
              animal: { id: matriz!.id },
              ocupacao: { baia: { id: baiaInseminacao!.id } },
              status: StatusOcupacaoAnimal.ATIVO
            }
          });
  
          if (ocupacaoAtiva) {
            throw new Error(`O animal ${matriz?.numero_brinco} já está na baia de destino ${baiaInseminacao?.numero}`);
          }

          const ocupacaoAtual = await this.ocupacaoService.tratarOcupacaoAtual(
            transactionalEntityManager, 
            matriz!.id, 
            usuario!
          );

          //se a matriz ja estava em uma baia, essa função vai remover a ocupação anterior 
          //e ja tratar a baia anterior caso fique fazia etc
          await this.ocupacaoService.tratarOcupacaoAtual(
            transactionalEntityManager, 
            matriz!.id, 
            usuario!
          );

          const ocupacaoDestino = await this.ocupacaoService.processarBaiaDestino(
            transactionalEntityManager, 
            fazenda,
            baiaInseminacao!.id,
            usuario!
          );

          await this.ocupacaoService.criarNovaOcupacaoAnimal(
            transactionalEntityManager, 
            ocupacaoDestino,
            matriz!,
            usuario!
          );

          // Registrar movimentação
          await this.ocupacaoService.registrarMovimentacao(
            transactionalEntityManager,
            fazenda,
            matriz!,
            ocupacaoAtual?.ocupacao?.baia,
            baiaInseminacao!,
            usuario!
          );

          // Registrar inseminação
          await this.registrarInseminacao(
            transactionalEntityManager,
            inseminacao,
            fazenda,
            usuario!
          );

          resultados.push({ 
            animal_id: matriz!.id,
            success: true,
            message: 'Animal movimentado com sucesso'
          });

        } catch (error) {
          const message = error instanceof Error ? error.message : 'Erro ao inseminar animal';
          
          erros.push({ 
            animal_id: inseminacao.porca_inseminada_id,
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
        total: inseminacoes.length,
        sucessos: resultados.length,
        falhas: erros.length
      };
      
    });
  }

  async registrarInseminacao(
    manager: EntityManager,
    data: InseminacaoData,
    fazenda: Fazenda,
    usuario: Usuario,
  ): Promise<Inseminacao> {

    const now = new Date();

    await manager.update(
      LoteAnimal,
      { 
        id: data.lote_animal_id
      },
      { 
        inseminado: true,
        updated_at: new Date()
      }
    );    

    await manager.update(
      Animal,
      { 
        id: data.porca_inseminada_id,
        fazenda: { id: fazenda.id }
      },
      { 
        data_ultima_inseminacao: data.data,
        updated_at: new Date()
      }
    );

    const inseminacao = manager.create(Inseminacao, {
        fazenda: fazenda,
        usuario,
        porcaInseminada: { id: data.porca_inseminada_id },
        porcoDoador: { id: data.porco_doador_id },
        loteAnimal: { id: data.lote_animal_id },
        baiaInseminacao: { id: data.baia_id },
        data: data.data,
        createdBy: usuario,
    });

    const savedInseminacao = await manager.save(inseminacao);

    const loteAnimal = await manager.findOne(LoteAnimal, {
      where: { id: data.lote_animal_id },
      relations: ['lote'],
    });

    if (loteAnimal && loteAnimal.lote) {
      const qtdNaoInseminados = await manager.count(LoteAnimal, {
        where: {
          lote: { id: loteAnimal.lote.id },
          inseminado: false,
        },
      });
  
      if (qtdNaoInseminados === 0) {
        // Último inseminado — encerrando o lote
        await manager.update(
          Lote,
          { id: loteAnimal.lote.id },
          {
            encerrado: true,
            data_fim: now,
            updated_at: now,
          }
        );
      }
    }

    return await manager.save(savedInseminacao);
  }
  
}
