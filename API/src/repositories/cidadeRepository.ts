import { AppDataSource } from "../data-source";
import { Cidade } from "../entities/Cidade";

export const fazendaRepository = AppDataSource.getRepository(Cidade);