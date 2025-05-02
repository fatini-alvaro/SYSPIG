import { AppDataSource } from "../data-source";
import { ValidationService } from "./ValidationService";
import { Usuario } from "../entities/Usuario";
import { StatusAnimal } from "../constants/animalConstants";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";
import { OcupacaoService } from "./OcupacaoService";
import { Venda } from "../entities/Venda";
import { vendaRepository } from "../repositories/vendaRepository";

interface vendaData {
  animal_id: number;
  baia_id: number;
}

interface VendaCreateData {
  peso: number;
  valor_venda: number;
  fazenda_id: number;
  usuarioIdAcao: number;
  data_venda: Date;
  quantidade: number;
  animais: vendaData[];
}

export class VendaService {

  private ocupacaoService = new OcupacaoService(); 

  async list(fazenda_id: number) {
    return await vendaRepository.find({
      where: {
          fazenda: { id: fazenda_id }
      },
      relations: ['createdBy'],
      order: { data_venda: "DESC" }
    });
  }
  
  async create(vendaData: VendaCreateData) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      let venda: Venda | null = null;

      const { fazenda, createdBy } =
        await this.validateVenda(vendaData);

      venda = transactionalEntityManager.create(Venda, { fazenda });

      venda.fazenda = fazenda;
      venda.data_venda = vendaData.data_venda;
      venda.createdBy = createdBy!;
      venda.quantidade_vendida = vendaData.quantidade;
      venda.peso_venda = vendaData.peso;
      venda.valor_venda = vendaData.valor_venda;

      await transactionalEntityManager.save(venda);

      //apos criar a venda é necessario tratar os leitoes vinculados 
      for (const leitao of vendaData.animais) {
        const animal = await ValidationService.validateAndReturnAnimal(leitao.animal_id);
        const baia = await ValidationService.validateAndReturnBaia(leitao.baia_id, fazenda);
      
        const ocupacao_animal_ativa = await animal?.getOcupacaoAtiva();
      
        if (ocupacao_animal_ativa) {
          ocupacao_animal_ativa.status = StatusOcupacaoAnimal.REMOVIDO;
          await transactionalEntityManager.save(ocupacao_animal_ativa);
        }
      
        if (animal) {
          animal.status = StatusAnimal.VENDIDO;
          await transactionalEntityManager.save(animal);
        }
      
        if (baia?.ocupacao) {
          await this.ocupacaoService.verificaSeOcupacaoEstaVaziaEncerraSeSim(
            transactionalEntityManager,
            baia.id,
            baia.ocupacao.id,
            createdBy!.id
          );
        }
      }

      return venda;      
    });
  }

  async validateVenda(vendaData: VendaCreateData) {
    const fazenda = await ValidationService.validateAndReturnFazenda(vendaData.fazenda_id);

    let createdBy: Usuario | null = null;

    createdBy = await ValidationService.validateAndReturnUsuario(vendaData.usuarioIdAcao);    

    return {
      fazenda,
      createdBy
    };
  }
  
}
