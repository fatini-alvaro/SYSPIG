import { AppDataSource } from "../data-source";
import { OcupacaoAnimal } from "../entities/OcupacaoAnimal";

export const ocupacaoAnimalRepository = AppDataSource.getRepository(OcupacaoAnimal);