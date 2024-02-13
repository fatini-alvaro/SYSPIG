import { AppDataSource } from "../data-source";
import { Granja } from "../entities/Granja";

export const granjaRepository = AppDataSource.getRepository(Granja);