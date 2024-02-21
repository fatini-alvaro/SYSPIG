import { AppDataSource } from "../data-source";
import { Cidade } from "../entities/Cidade";

export const cidadeRepository = AppDataSource.getRepository(Cidade);