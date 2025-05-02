import { AppDataSource } from "../data-source";
import { Venda } from "../entities/Venda";

export const vendaRepository = AppDataSource.getRepository(Venda);