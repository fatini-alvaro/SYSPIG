import { AppDataSource } from '../data-source';
import { Fazenda } from '../entities/Fazenda';
import { Animal } from '../entities/Animal';
import { Baia } from '../entities/Baia';
import { Usuario } from '../entities/Usuario';
import { ValidationError } from '../utils/validationError';
import { Anotacao } from '../entities/Anotacao';

export class ValidationService {
  static async validateAndReturnFazenda(fazendaId: number): Promise<Fazenda> {
    if (!fazendaId) {
      throw new ValidationError('A fazenda é obrigatória.');
    }
    
    const fazenda = await AppDataSource.getRepository(Fazenda).findOneBy({ id: fazendaId });
    if (!fazenda) {
      throw new ValidationError('Fazenda não encontrada.', 404);
    }
    
    return fazenda;
  }

  static async validateAndReturnAnimal(animalId?: number, fazenda?: Fazenda): Promise<Animal | null> {
    if (!animalId) return null;

    const animal = await AppDataSource.getRepository(Animal).findOne({
      where: { id: animalId },
      relations: ['fazenda'],
    });

    if (!animal) {
      throw new ValidationError('Animal não encontrado.', 404);
    }

    if (fazenda && animal.fazenda.id !== fazenda.id) {
      throw new ValidationError('O animal informado não pertence à mesma fazenda.');
    }

    return animal;
  }

  static async validateAndReturnBaia(baiaId?: number, fazenda?: Fazenda): Promise<Baia | null> {
    if (!baiaId) return null;

    const baia = await AppDataSource.getRepository(Baia).findOne({
      where: { id: baiaId },
      relations: ['fazenda'],
    });

    if (!baia) {
      throw new ValidationError('Baia não encontrada.', 404);
    }

    if (fazenda && baia.fazenda.id !== fazenda.id) {
      throw new ValidationError('A baia informada não pertence à mesma fazenda.');
    }

    return baia;
  }

  static async validateAndReturnUsuario(usuarioId?: number): Promise<Usuario | null> {
    if (!usuarioId) return null;

    const usuario = await AppDataSource.getRepository(Usuario).findOneBy({ id: usuarioId });
    if (!usuario) {
      throw new ValidationError('Usuário não encontrado.', 404);
    }

    return usuario;
  }

  static async validateAndReturnAnotacao(anotacaoId?: number): Promise<Anotacao | null> {
    if (!anotacaoId) return null;

    const anotacao = await AppDataSource.getRepository(Anotacao).findOneBy({ id: anotacaoId });
    if (!anotacao) {
      throw new ValidationError('Anotação não encontrado.', 404);
    }

    return anotacao;
  }
}