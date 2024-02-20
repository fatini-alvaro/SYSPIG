import { AppDataSource } from "../data-source";
import { Baia } from "../entities/Baia";

export const baiaRepository = AppDataSource.getRepository(Baia);