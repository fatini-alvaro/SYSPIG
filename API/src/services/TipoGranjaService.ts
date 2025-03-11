import { tipoGranjaRepository } from "../repositories/tipoGranjaRepository";

export class TipoGranjaService {

  async list() {
    return await tipoGranjaRepository.find();
  }
}
