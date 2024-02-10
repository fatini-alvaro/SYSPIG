import { AppDataSource } from "../data-source";
import { Fazenda } from "../entities/Fazenda";

export const fazendaRepository = AppDataSource.getRepository(Fazenda);