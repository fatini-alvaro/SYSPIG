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
  
}
