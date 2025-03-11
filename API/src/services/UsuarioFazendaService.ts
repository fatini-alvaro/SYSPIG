import { AppDataSource } from "../data-source";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { usuarioFazendaRepository } from "../repositories/usuarioFazendaRepository";
import { UsuarioFazenda } from "../entities/UsuarioFazenda";
import { Fazenda } from "../entities/Fazenda";
import { EntityManager } from "typeorm";

interface UsuarioFazendaCreateOrUpdateData {
  tipo_usuario_id: number;
  usuario_id: number;
  fazenda: Fazenda;
}

export class UsuarioFazendaService {

  async list(usuario_id: number) {
    return await usuarioFazendaRepository.find({ 
      where: { 
        usuario: { 
          id: Number(usuario_id) 
        } 
      },
      select: ['id'],
      order: { id: 'ASC' }
    });
  }

  async listFazendas(usuario_id: number) {
    const usuarioFazendas = await usuarioFazendaRepository.find({ 
      where: { 
        usuario: { 
          id: Number(usuario_id) 
        } 
      }, 
      relations: ['fazenda', 'fazenda.cidade', 'fazenda.cidade.uf']
    });

    const fazendas = usuarioFazendas.map(usuarioFazenda => usuarioFazenda.fazenda);

    return fazendas;
  }

  async createOrUpdate(usuarioFazendaData: UsuarioFazendaCreateOrUpdateData, transactionalEntityManager: EntityManager) {
    let usuarioFazenda: UsuarioFazenda | null = null;
  
    const { tipoUsuarioInstancia, usuarioInstancia } =
      await this.validateUsuarioFazenda(usuarioFazendaData);
  
    usuarioFazenda = transactionalEntityManager.create(UsuarioFazenda, {
      tipoUsuario: tipoUsuarioInstancia ?? null,
      usuario: usuarioInstancia ?? null,
      fazenda: usuarioFazendaData.fazenda,
    });
  
    await transactionalEntityManager.save(usuarioFazenda);
    return usuarioFazenda;
  }  

  async validateUsuarioFazenda(usuarioFazendaData: UsuarioFazendaCreateOrUpdateData, usuarioFazenda?: UsuarioFazenda | null) {
    const tipoUsuarioInstancia = await ValidationService.validateAndReturnTipoUsuario(usuarioFazendaData.tipo_usuario_id);
    const usuarioInstancia = await ValidationService.validateAndReturnUsuario(usuarioFazendaData.usuario_id);

    return {
      tipoUsuarioInstancia, 
      usuarioInstancia,
    };
  }
}
