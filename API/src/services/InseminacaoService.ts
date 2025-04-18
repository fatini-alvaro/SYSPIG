import { AppDataSource } from "../data-source";
import { animalRepository } from "../repositories/animalRepository";
import { Animal } from "../entities/Animal";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { Usuario } from "../entities/Usuario";
import { SexoAnimal, StatusAnimal } from "../constants/animalConstants";
import { IsNull, Not } from "typeorm";
import { OcupacaoAnimal } from "../entities/OcupacaoAnimal";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";
import { OcupacaoService } from "./OcupacaoService";
import { Inseminacao } from "../entities/Inseminacao";

interface InseminacaoData {
  porca_inseminada_id: number;
  porco_doador_id: number;
  lote_animal_id: number;
  baia_id: number;
  data: Date;
}

interface InseminacaoData {
  fazenda_id: number;
  usuarioIdAcao: number;
  inseminacoes: InseminacaoData[];
}

export class InseminacaoService {

  async list(fazenda_id: number) {

  }

  async inseminarAnimais(data: InseminacaoData) {
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

        } catch (error) {
          const message = error instanceof Error ? error.message : 'Erro ao inseminar animal';
          
          erros.push({ 
            numero_brinco_animal: inseminacao.porca_inseminada_id,
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
  
}
