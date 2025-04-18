import { AppDataSource } from "../data-source";
import { animalRepository } from "../repositories/animalRepository";
import { Animal } from "../entities/Animal";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { Usuario } from "../entities/Usuario";
import { SexoAnimal, StatusAnimal } from "../constants/animalConstants";
import { IsNull, Not } from "typeorm";
import { OcupacaoAnimal } from "../entities/OcupacaoAnimal";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";
import { OcupacaoService } from "./OcupacaoService";

export class InseminacaoService {

  async list(fazenda_id: number) {

  }
  
}
