import { AppDataSource } from "../data-source";
import { Uf } from "../entities/Uf";

export const ufRepository = AppDataSource.getRepository(Uf);