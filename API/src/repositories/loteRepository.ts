import { AppDataSource } from "../data-source";
import { Lote } from "../entities/Lote";

export const loteRepository = AppDataSource.getRepository(Lote);