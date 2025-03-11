import { cidadeRepository } from "../repositories/cidadeRepository";

export class CidadeService {

  async list() {
    return await cidadeRepository.find({ 
      relations: ['uf'],
      order: {
        nome: 'ASC'
      }
    });
  }
}
