
import { Between } from "typeorm";
import { SexoAnimal, StatusAnimal } from "../constants/animalConstants";
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
import { Animal } from "../entities/Animal";
import { addDays, subDays } from "date-fns";

export class DashboardService {

  private inseminacaoRepository = AppDataSource.getRepository(Inseminacao);
  private nascimentoRepository = AppDataSource.getRepository(Nascimento);
  private ocupacaoAnimalRepository = AppDataSource.getRepository(OcupacaoAnimal);
  private anotacaoRepository = AppDataSource.getRepository(Anotacao);
  private loteRepository = AppDataSource.getRepository(Lote);
  private baiaRepository = AppDataSource.getRepository(Baia);
  private movimentacaoRepository = AppDataSource.getRepository(Movimentacao);
  private animalRepository = AppDataSource.getRepository(Animal);

  async returnData(fazenda_id: number, startDate?: Date, endDate?: Date) {

    const hoje = new Date();
    const inicioDoDiaHoje = new Date(hoje.setHours(0, 0, 0, 0));
    const fimDoDiaHoje = new Date(hoje.setHours(23, 59, 59, 999));

    const todayStart = startDate || hoje;
    todayStart.setHours(0, 0, 0, 0);

    const todayEnd = endDate || hoje;
    todayEnd.setHours(23, 59, 59, 999);

    const totalInseminacoes = await this.inseminacaoRepository.count({
      where: { fazenda: { id: fazenda_id }, data: Between(todayStart, todayEnd) }
    });

    const nascimentosVivos = await this.nascimentoRepository
      .createQueryBuilder("nascimento")
      .innerJoin("nascimento.animal", "animal")
      .where("nascimento.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("nascimento.data_nascimento BETWEEN :startDate AND :endDate", {
        startDate: todayStart,
        endDate: todayEnd,
      })
      .andWhere("animal.status = :status", { status: StatusAnimal.VIVO })
      .getCount();

    const nascimentosMortos = await this.nascimentoRepository
      .createQueryBuilder("nascimento")
      .innerJoin("nascimento.animal", "animal")
      .where("nascimento.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("nascimento.data_nascimento BETWEEN :startDate AND :endDate", {
        startDate: todayStart,
        endDate: todayEnd,
      })
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

    const totalAnimais = await this.animalRepository
      .createQueryBuilder("animal")
      .where("animal.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("animal.nascimento = :naoNascimento", { naoNascimento: false })
      .andWhere("animal.status = :status", { status: StatusAnimal.VIVO })
      .getCount();

    const movimentacoes = await this.movimentacaoRepository.find({
        where: {
          fazenda: { id: fazenda_id },
          dataMovimentacao: Between(todayStart, todayEnd),
        },
        relations: ['animal', 'baiaOrigem', 'baiaDestino', 'usuario'],
        take: 10,
        order: { dataMovimentacao: "DESC" },
      });

    const movimentacoesCount = await this.movimentacaoRepository.find({
        where: {
          fazenda: { id: fazenda_id },
          dataMovimentacao: Between(todayStart, todayEnd),
        },
      }).then(movimentacoes => movimentacoes.length)

    const anotacoes = await this.anotacaoRepository.find({
      where: { fazenda: { id: fazenda_id }, data: Between(todayStart, todayEnd) },
      relations: ["baia",  "animal", "createdBy"],
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

    const leitoesQuery = await this.baiaRepository
      .createQueryBuilder("baia")
      .innerJoin("baia.granja", "granja")
      .innerJoin("granja.tipoGranja", "tipoGranja")
      .innerJoin("baia.ocupacoes", "ocupacao")
      .innerJoin("ocupacao.ocupacaoAnimais", "ocupacaoAnimal")
      .innerJoin("ocupacaoAnimal.animal", "animal")
      .where("baia.fazenda_id = :fazendaId", { fazendaId: fazenda_id })
      .andWhere("tipoGranja.id = :tipoGranjaId", { tipoGranjaId: TipoGranjaId.CRECHE })
      .andWhere("ocupacaoAnimal.status = :statusAtivo", { statusAtivo: StatusOcupacaoAnimal.ATIVO })
      .select([
        "COUNT(ocupacaoAnimal.id) AS count",
        "AVG(DATE_PART('day', NOW() - animal.data_nascimento)) AS media_idade"
      ])
      .getRawOne();
    
    const leitoesEmCreche = Number(leitoesQuery.count);
    const mediaIdadeDias = Number(leitoesQuery.media_idade);

    const diasParaGestacao = 114;
    const diasAntesParaAviso = 14;
    
    const dataInicial = subDays(hoje, diasParaGestacao);
    const dataFinal = subDays(hoje, diasParaGestacao - diasAntesParaAviso);

    const matrizesProxDoParto = await this.animalRepository.find({
      where: {
        status: StatusAnimal.VIVO,
        nascimento: false,
        fazenda: { id: fazenda_id },
        sexo: SexoAnimal.FEMEA,
        data_ultima_inseminacao: Between(dataInicial, dataFinal),
      },
    });

    const matrizesProxDoPartoComDadosCalculados = await Promise.all(matrizesProxDoParto.map(async (matriz) => {
      // Calcular a data prevista para o parto
      const dataPrevisaoParto = new Date(matriz.data_ultima_inseminacao);
      dataPrevisaoParto.setDate(dataPrevisaoParto.getDate() + diasParaGestacao);
    
      // Calcular os dias restantes
      const hoje = new Date();
      const diasRestantes = Math.ceil((dataPrevisaoParto.getTime() - hoje.getTime()) / (1000 * 3600 * 24));
    
      // Obter a baia associada ao animal (caso exista)
      const ocupacaoAtiva = await matriz.getOcupacaoAtiva();
      const baia = ocupacaoAtiva ? ocupacaoAtiva.ocupacao.baia.numero : "Desconhecida"; // Ajuste conforme o nome do campo correto
    
      // Calcular a paridade (se não tiver criado, pode ser 0)
      const paridade = matriz.nascimento ? 1 : 0;
    
      return {
        id: matriz.id,
        brinco: matriz.numero_brinco,
        dataPrevisaoParto: dataPrevisaoParto.toISOString().split('T')[0], // No formato YYYY-MM-DD
        diasRestantes,
        baia,
        paridade,
      };
    }));

    // Parte do gráfico de ocupação de baias
    const totalBaias = await this.baiaRepository.count({ where: { fazenda: { id: fazenda_id } } });
    const baiasOcupadas = await this.baiaRepository.count({ where: { fazenda: { id: fazenda_id }, vazia: false } });
    const baiasLivres = totalBaias - baiasOcupadas;

    const partosAgrupadosPorMatrizLote = await this.nascimentoRepository
      .createQueryBuilder("nascimento")
      .leftJoin("nascimento.matriz", "matriz")
      .select("nascimento.matriz_id", "matrizId")
      .addSelect("matriz.numero_brinco", "numeroBrinco")
      .addSelect("nascimento.lote_nascimento_id", "loteNascimentoId")
      .addSelect("COUNT(nascimento.id)", "totalLeitoes")
      .where("nascimento.fazenda_id = :fazenda_id", { fazenda_id })
      .groupBy("nascimento.matriz_id")
      .addGroupBy("nascimento.lote_nascimento_id")
      .addGroupBy("matriz.numero_brinco")
      .getRawMany();

    // Cálculo da média geral
    const totalLeitoes = partosAgrupadosPorMatrizLote.reduce((sum, r) => sum + Number(r.totalLeitoes), 0);
    const totalPartos = partosAgrupadosPorMatrizLote.length;
    const mediaLeitoesPorParto = totalPartos > 0 ? totalLeitoes / totalPartos : 0;

    const totalNascimentos = await this.nascimentoRepository
      .createQueryBuilder("nascimento")
      .where("nascimento.fazenda_id = :fazenda_id", { fazenda_id })
      .getCount();

    const totalMortos = await this.nascimentoRepository
      .createQueryBuilder("nascimento")
      .leftJoin("nascimento.animal", "animal")
      .where("nascimento.fazenda_id = :fazenda_id", { fazenda_id })
      .andWhere("animal.status = :status", { status: StatusAnimal.MORTO })
      .getCount();

    const taxaMortalidade = totalNascimentos > 0 
      ? (totalMortos / totalNascimentos) * 100 
      : 0;

    const matrizMap = new Map<number, { total: number, partos: number, numeroBrinco: string }>();

    partosAgrupadosPorMatrizLote.forEach(n => {
      const matrizId = Number(n.matrizId);
      const total = Number(n.totalLeitoes);
      const numeroBrinco = n.numeroBrinco;
    
      if (!matrizMap.has(matrizId)) {
        matrizMap.set(matrizId, { total: 0, partos: 0, numeroBrinco });
      }
    
      const entry = matrizMap.get(matrizId)!;
      entry.total += total;
      entry.partos += 1;
    });
    
    // Agora calcular médias e ordenar
    const medias = Array.from(matrizMap.entries()).map(([matrizId, data]) => ({
      matrizId,
      numeroBrinco: data.numeroBrinco,
      mediaPorParto: data.total / data.partos,
      totalPartos: data.partos,
    }));
    
    const topMatrizesPorMedia = medias
      .sort((a, b) => b.mediaPorParto - a.mediaPorParto)
      .slice(0, 3); 

    const topMatrizesPorTotalNascimentos = (
      await this.nascimentoRepository
        .createQueryBuilder("nascimento")
        .leftJoin("nascimento.matriz", "animal")
        .select("animal.numero_brinco", "numeroBrinco")
        .addSelect("nascimento.matriz_id", "matrizId")
        .addSelect("COUNT(nascimento.id)", "totalNascimentos")
        .groupBy("nascimento.matriz_id")
        .addGroupBy("animal.numero_brinco")
        .orderBy("COUNT(nascimento.id)", "DESC")
        .limit(3)
        .getRawMany()
    ).map(matriz => {
      const dados = matrizMap.get(Number(matriz.matrizId));
      return {
        ...matriz,
        totalPartos: dados?.partos ?? 0,
      };
    });   

    return {
      totalInseminacoes,
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
      },
      totalAnimais,
      totalMovimentacoes: movimentacoesCount,
      matrizesProxDoPartoComDadosCalculados,
      mediaLeitoesPorParto,
      topMatrizesPorTotalNascimentos,
      topMatrizesPorMedia,
      taxaMortalidade,
      leitoesEmCrecheObj: {
        total: leitoesEmCreche,
        idadeMedia: mediaIdadeDias
      }
    };    
  }
}
