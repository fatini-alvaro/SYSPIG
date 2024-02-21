import { AppDataSource } from "../data-source";
import { Inseminacao } from "../entities/Inseminacao";

export const inseminacaoRepository = AppDataSource.getRepository(Inseminacao);