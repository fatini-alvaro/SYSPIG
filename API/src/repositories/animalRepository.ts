import { AppDataSource } from "../data-source";
import { Animal } from "../entities/Animal";

export const animalRepository = AppDataSource.getRepository(Animal);