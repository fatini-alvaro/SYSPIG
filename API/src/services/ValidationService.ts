import { AppDataSource } from '../data-source';
import { Fazenda } from '../entities/Fazenda';
import { Animal } from '../entities/Animal';
import { Baia } from '../entities/Baia';
import { Usuario } from '../entities/Usuario';
import { ValidationError } from '../utils/validationError';
import { Anotacao } from '../entities/Anotacao';
import { Granja } from '../entities/Granja';
import { TipoGranja } from '../entities/TipoGranja';
import { Lote } from '../entities/Lote';
import { Cidade } from '../entities/Cidade';
import { UsuarioFazenda } from '../entities/UsuarioFazenda';
import { TipoUsuario } from '../entities/TipoUsuario';

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

    const usuario = await AppDataSource.getRepository(Usuario).findOne({
      where: { id: usuarioId },
      relations: ["tipoUsuario"],
    });
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

  static async validateAndReturnGranja(granjaId?: number): Promise<Granja | null> {
    if (!granjaId) return null;

    const granja = await AppDataSource.getRepository(Granja).findOneBy({ id: granjaId });
    if (!granja) {
      throw new ValidationError('Granja não encontrada.', 404);
    }

    return granja;
  }

  static async validateAndReturnTipoGranja(tipoGranjaId?: number): Promise<TipoGranja | null> {
    if (!tipoGranjaId) return null;

    const tipoGranja = await AppDataSource.getRepository(TipoGranja).findOne({
      where: { id: tipoGranjaId }
    });

    if (!tipoGranja) {
      throw new ValidationError('Tipo Granja não encontrado.', 404);
    }

    return tipoGranja;
  }

  static async validateAndReturnLote(loteId?: number): Promise<Lote | null> {
    if (!loteId) return null;

    const lote = await AppDataSource.getRepository(Lote).findOneBy({ id: loteId });
    if (!lote) {
      throw new ValidationError('Lote não encontrada.', 404);
    }

    return lote;
  }

  static async validateAndReturnCidade(cidadeId?: number): Promise<Cidade | null> {
    if (!cidadeId) return null;

    const cidade = await AppDataSource.getRepository(Cidade).findOneBy({ id: cidadeId });
    if (!cidade) {
      throw new ValidationError('Cidade não encontrada.', 404);
    }

    return cidade;
  }

  static async validateAndReturnUsuarioFazenda(usuarioFazendaId?: number): Promise<UsuarioFazenda | null> {
    if (!usuarioFazendaId) return null;

    const usuarioFazenda = await AppDataSource.getRepository(UsuarioFazenda).findOne({
      where: { id: usuarioFazendaId }
    });

    if (!usuarioFazenda) {
      throw new ValidationError('Usuário Fazenda não encontrado.', 404);
    }

    return usuarioFazenda;
  }

  static async validateAndReturnTipoUsuario(tipoUsuarioId?: number): Promise<TipoUsuario | null> {
    if (!tipoUsuarioId) return null;

    const tipoUsuario = await AppDataSource.getRepository(TipoUsuario).findOne({
      where: { id: tipoUsuarioId }
    });

    if (!tipoUsuario) {
      throw new ValidationError('Tipo Usuário não encontrado.', 404);
    }

    return tipoUsuario;
  }

}