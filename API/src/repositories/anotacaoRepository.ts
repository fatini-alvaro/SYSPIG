import { AppDataSource } from "../data-source";
import { Anotacao } from "../entities/Anotacao";

export const anotacaoRepository = AppDataSource.getRepository(Anotacao);