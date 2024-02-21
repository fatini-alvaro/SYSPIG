import { AppDataSource } from "../data-source";
import { TipoGranja } from "../entities/TipoGranja";

export const tipoGranjaRepository = AppDataSource.getRepository(TipoGranja);