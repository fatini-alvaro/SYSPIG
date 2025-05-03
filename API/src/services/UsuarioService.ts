import { usuarioRepository } from "../repositories/usuarioRepository";
import bcrypt from 'bcrypt';
import { tipoUsuarioRepository } from "../repositories/tipoUsuarioRepository";
import { TipoUsuarioId } from "../constants/tipoUsuarioConstants";
import { ValidationError } from "../utils/validationError";

export class UsuarioService {

  async create(nome: string, email: string, senha: string) {
    if (!nome || !email || !senha) {
      throw new ValidationError('Todos os campos são obrigatórios.');
    }

    const existingUsuario = await usuarioRepository.findOneBy({ email });
    if (existingUsuario) {
      throw new ValidationError('O e-mail já está em uso.');
    }

    const tipoUsuarioInstancia = await tipoUsuarioRepository.findOneBy({ id: Number(TipoUsuarioId.DONO) });
    if (!tipoUsuarioInstancia) {
      throw new ValidationError('Tipo de usuário não encontrado.');
    }

    const hashedPassword = await bcrypt.hash(senha, 10);

    const newUsuario = usuarioRepository.create({
      nome,
      email,
      senha: hashedPassword,
      tipoUsuario: tipoUsuarioInstancia
    });

    await usuarioRepository.save(newUsuario);

    return {
      id: newUsuario.id,
      nome: newUsuario.nome,
      email: newUsuario.email,
      tipoUsuario: newUsuario.tipoUsuario
    };
  }

  async listByFazenda(fazenda_id: number) {
    const usuarios = await usuarioRepository
      .createQueryBuilder('usuario')
      .innerJoin('usuario.usuarioFazendas', 'usuarioFazenda')
      .leftJoin('usuario.tipoUsuario', 'tipoUsuario')
      .where('usuarioFazenda.fazenda_id = :fazenda_id', { fazenda_id })
      .select([
        'usuario.id',
        'usuario.nome',
        'usuario.email',
        'usuario.created_at',
        'tipoUsuario.id',
        'tipoUsuario.descricao',
      ])
      .orderBy('usuario.created_at', 'DESC')
      .getRawMany();
  
    return usuarios.map(u => ({
      id: u.usuario_id,
      nome: u.usuario_nome,
      email: u.usuario_email,
      createdAt: u.usuario_created_at,
      tipoUsuario: {
        id: u.tipoUsuario_id,
        descricao: u.tipoUsuario_descricao,
      },
    }));
  }

  async getPerfilUsuario(userId: number) {
    const usuario = await usuarioRepository
      .createQueryBuilder('usuario')
      .leftJoin('usuario.tipoUsuario', 'tipoUsuario')
      .where('usuario.id = :userId', { userId })
      .select([
        'usuario.id',
        'usuario.nome',
        'usuario.email',
        'usuario.created_at',
        'tipoUsuario.id',
        'tipoUsuario.descricao',
      ])
      .getOne();
  
    if (!usuario) {
      throw new Error('Usuário não encontrado');
    }
  
    return {
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email,
      created_at: usuario.created_at,
      tipoUsuario: usuario.tipoUsuario
        ? {
            id: usuario.tipoUsuario.id,
            descricao: usuario.tipoUsuario.descricao,
          }
        : null,
    };
  }
  
  
}
