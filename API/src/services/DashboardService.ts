
import { Between } from "typeorm";
import { StatusAnimal } from "../constants/animalConstants";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";
import { TipoGranjaId } from "../constants/tipoGranjaConstants";
import { AppDataSource } from "../data-source";
import { Anotacao } from "../entities/Anotacao";
import { Baia } from "../entities/Baia";
import { Inseminacao } from "../entities/Inseminacao";
import { Lote } from "../entities/Lote";
import { Movimentacao } from "../entities/movimentacao";
import { Nascimento } from "../entities/nascimento";
import { OcupacaoAnimal } from "../entities/OcupacaoAnimal";

export class DashboardService {

  private inseminacaoRepository = AppDataSource.getRepository(Inseminacao);
  private nascimentoRepository = AppDataSource.getRepository(Nascimento);
  private ocupacaoAnimalRepository = AppDataSource.getRepository(OcupacaoAnimal);
  private anotacaoRepository = AppDataSource.getRepository(Anotacao);
  private loteRepository = AppDataSource.getRepository(Lote);
  private baiaRepository = AppDataSource.getRepository(Baia);
  private movimentacaoRepository = AppDataSource.getRepository(Movimentacao);

  async returnData(fazenda_id: number) {

    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);

    const todayEnd = new Date();
    todayEnd.setHours(23, 59, 59, 999);

    const inseminacoesHoje = await this.inseminacaoRepository.count({
      where: { fazenda: { id: fazenda_id }, data: Between(todayStart, todayEnd) }
    });

    const nascimentosVivos = await this.nascimentoRepository
      .createQueryBuilder("nascimento")
      .innerJoin("nascimento.animal", "animal")
      .where("nascimento.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("DATE(nascimento.data_nascimento) = CURRENT_DATE")
      .andWhere("animal.status = :status", { status: StatusAnimal.VIVO })
      .getCount();

    const nascimentosMortos = await this.nascimentoRepository
      .createQueryBuilder("nascimento")
      .innerJoin("nascimento.animal", "animal")
      .where("nascimento.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("DATE(nascimento.data_nascimento) = CURRENT_DATE")
      .andWhere("animal.status = :status", { status: StatusAnimal.MORTO })
      .getCount();

    const animaisEmBaias = await this.ocupacaoAnimalRepository
      .createQueryBuilder("ocupacao_animal")
      .innerJoin("ocupacao_animal.ocupacao", "ocupacao")
      .innerJoin("ocupacao_animal.animal", "animal")
      .where("ocupacao.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("ocupacao_animal.status = :status", { status: StatusOcupacaoAnimal.ATIVO })
      .andWhere("animal.nascimento = :naoNascimento", { naoNascimento: false })
      .getCount();

    const anotacoes = await this.anotacaoRepository.find({
      where: { fazenda: { id: fazenda_id }, data: Between(todayStart, todayEnd) },
      relations: ["baia", "createdBy"],
    });

    const lotesAtivos = await this.loteRepository.count({
      where: { fazenda: { id: fazenda_id }, encerrado: false }
    });

    const matrizesGestando = await this.baiaRepository
      .createQueryBuilder("baia")
      .innerJoin("baia.granja", "g")
      .innerJoin("g.tipoGranja", "tg")
      .where("baia.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("tg.id = :tipoGranjaId", { tipoGranjaId: TipoGranjaId.GESTACAO })
      .andWhere("baia.vazia = :naoVazia", { naoVazia: false })
      .getCount();

    const leitoesEmCreche = await this.baiaRepository
      .createQueryBuilder("baia")
      .innerJoin("baia.granja", "g")
      .innerJoin("g.tipoGranja", "tg")
      .where("baia.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("tg.id = :tipoGranjaId", { tipoGranjaId: TipoGranjaId.CRECHE })
      .andWhere("baia.vazia = :naoVazia", { naoVazia: false })
      .getCount();

    const movimentacoes = await this.movimentacaoRepository.count({
      where: { fazenda: { id: fazenda_id }, dataMovimentacao: new Date() }
    });

    // Parte do gráfico de ocupação de baias
    const totalBaias = await this.baiaRepository.count({ where: { fazenda: { id: fazenda_id } } });
    const baiasOcupadas = await this.baiaRepository.count({ where: { fazenda: { id: fazenda_id }, vazia: false } });
    const baiasLivres = totalBaias - baiasOcupadas;

    return {
      inseminacoesHoje,
      nascimentosVivos,
      nascimentosMortos,
      animaisEmBaias,
      anotacoesDoDia: {
        quantidade: anotacoes.length,
        lista: anotacoes,
      },
      lotesAtivos,
      matrizesGestando,
      leitoesEmCreche,
      movimentacoes,
      ocupacaoBaias: {
        ocupadas: baiasOcupadas,
        livres: baiasLivres,
      }
    };    
  }
}
