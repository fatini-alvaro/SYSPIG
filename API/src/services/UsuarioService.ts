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

  async update(userId: number, data: {
    nome?: string
    email?: string
  }) {
    const usuario = await usuarioRepository.findOne({
      where: { id: userId },
      relations: ['tipoUsuario'],
    });
  
    if (!usuario) {
      throw new ValidationError('Usuário não encontrado.');
    }
  
    if (data.email && data.email !== usuario.email) {
      const emailEmUso = await usuarioRepository.findOneBy({ email: data.email });
      if (emailEmUso) {
        throw new ValidationError('Este e-mail já está em uso por outro usuário.');
      }
      usuario.email = data.email;
    }
  
    if (data.nome) {
      usuario.nome = data.nome;
    }
  
    await usuarioRepository.save(usuario);
  
    return {
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email
    };
  }

  async changePassword(userId: number, senhaAtual: string, novaSenha: string) {
    const usuario = await usuarioRepository.findOneBy({ id: userId });
  
    if (!usuario) {
      throw new ValidationError('Usuário não encontrado.');
    }
  
    const senhaCorreta = await bcrypt.compare(senhaAtual, usuario.senha);
    if (!senhaCorreta) {
      throw new ValidationError('Senha atual incorreta.');
    }
  
    if (novaSenha.length < 6) {
      throw new ValidationError('A nova senha deve ter pelo menos 6 caracteres.');
    }
  
    const novaSenhaCriptografada = await bcrypt.hash(novaSenha, 10);
    usuario.senha = novaSenhaCriptografada;
  
    await usuarioRepository.save(usuario);
  
    return { message: 'Senha alterada com sucesso.' };
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
      .leftJoinAndSelect('usuario.tipoUsuario', 'tipoUsuario')
      .leftJoinAndSelect('usuario.usuarioFazendas', 'usuarioFazenda')
      .leftJoinAndSelect('usuarioFazenda.fazenda', 'fazenda')
      .leftJoinAndSelect('fazenda.cidade', 'cidade')
      .leftJoinAndSelect('cidade.uf', 'uf')
      .where('usuario.id = :userId', { userId })
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
        usuarioFazendas: usuario.usuarioFazendas?.map(uf => ({
          id: uf.id,
          fazenda: {
            id: uf.fazenda!.id,
            nome: uf.fazenda!.nome,
            cidade: uf.fazenda!.cidade
              ? {
                  nome: uf.fazenda!.cidade.nome,
                  uf: uf.fazenda!.cidade.uf
                    ? { sigla: uf.fazenda!.cidade.uf.sigla }
                    : undefined,
                }
              : undefined,
          },
        })),
    };
  }  
  
}
