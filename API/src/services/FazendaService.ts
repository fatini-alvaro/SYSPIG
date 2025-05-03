import { AppDataSource } from "../data-source";
import { ValidationService } from "./ValidationService";
import { ValidationError } from "../utils/validationError";
import { Usuario } from "../entities/Usuario";
import { Fazenda } from "../entities/Fazenda";
import { UsuarioFazendaService } from "./UsuarioFazendaService";
import { fazendaRepository } from "../repositories/fazendaRepository";

interface FazendaCreateOrUpdateData {
  nome: string;
  cidade_id: number;
  usuarioIdAcao: number;
}

export class FazendaService {

  private usuarioFazendaService: UsuarioFazendaService;

  constructor() {
    this.usuarioFazendaService = new UsuarioFazendaService();
  }

  async createOrUpdate(fazendaData: FazendaCreateOrUpdateData, fazenda_id?: number) {
    return await AppDataSource.transaction(async transactionalEntityManager => {
      let fazenda: Fazenda | null = null;

      if (fazenda_id) {
        fazenda = await ValidationService.validateAndReturnFazenda(fazenda_id);
      }

      const { usuarioInstancia, cidadeInstancia, createdBy, updatedBy } =
        await this.validateFazenda(fazendaData, fazenda);

      if (!fazenda) {
        fazenda = transactionalEntityManager.create(Fazenda);
      }

      fazenda.nome = fazendaData.nome;
      fazenda.cidade = cidadeInstancia ?? null;
      fazenda.usuario = usuarioInstancia ?? null;
      fazenda.createdBy = createdBy ?? fazenda.createdBy;
      fazenda.updatedBy = updatedBy ?? fazenda.updatedBy;

      await transactionalEntityManager.save(fazenda);

      if (!fazenda_id) {
        // Criar usuário fazenda passando a instância da fazenda diretamente
        await this.usuarioFazendaService.createOrUpdate({
          tipo_usuario_id: usuarioInstancia?.tipoUsuario?.id ?? 0,
          usuario_id: fazendaData.usuarioIdAcao,
          fazenda, // Passa a instância da fazenda diretamente
        }, transactionalEntityManager);
      }  

      return fazenda;
    });
  }

  async validateFazenda(fazendaData: FazendaCreateOrUpdateData, fazenda?: Fazenda | null) {
    
    const usuarioInstancia = await ValidationService.validateAndReturnUsuario(fazendaData.usuarioIdAcao);
    const cidadeInstancia = await ValidationService.validateAndReturnCidade(fazendaData.cidade_id);

    let createdBy: Usuario | null = null;
    let updatedBy: Usuario | null = null;

    if (fazenda) {
      updatedBy = await ValidationService.validateAndReturnUsuario(fazendaData.usuarioIdAcao);
    } else {
      createdBy = await ValidationService.validateAndReturnUsuario(fazendaData.usuarioIdAcao);
    }

    return {
      usuarioInstancia,
      cidadeInstancia,
      createdBy,
      updatedBy,
    };
  }

  async listFazendasDisponiveis(usuario_id: number) {
    const fazendas = await fazendaRepository.find({ 
      where: { 
        usuario: { 
          id: Number(usuario_id) 
        } 
      }, 
      relations: ['cidade', 'cidade.uf']
    });

    return fazendas;
  }
}
