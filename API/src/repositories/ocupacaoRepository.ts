import { AppDataSource } from "../data-source";
import { Ocupacao } from "../entities/Ocupacao";

export const ocupacaoRepository = AppDataSource.getRepository(Ocupacao);