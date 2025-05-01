import { usuarioRepository } from "../repositories/usuarioRepository";
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { ValidationError } from "../utils/validationError";

export class AuthService {

  async auth(email: string, senha: string) {
    const usuario = await usuarioRepository.findOne({
      where: { email },
      relations: ['tipoUsuario']
    });
    
    if (!usuario) {
      throw new ValidationError('Usuário não encontrado.');
    }

    const isPasswordValid = await bcrypt.compare(senha, usuario.senha);
    if (!isPasswordValid) {
      throw new ValidationError('Credenciais inválidas.');
    }

    if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
      throw new ValidationError('As variáveis JWT_SECRET ou JWT_REFRESH_SECRET não foram definidas no .env');
    }

    const refreshToken = jwt.sign(
      { id: usuario.id, email: usuario.email },
      process.env.JWT_REFRESH_SECRET,
      { expiresIn: '7d' }
    );

    usuario.refreshToken = refreshToken;
    await usuarioRepository.save(usuario);

    const accessToken = jwt.sign(
      { id: usuario.id, email: usuario.email },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    return { usuario, accessToken, refreshToken };
  }

  async refreshToken(refreshToken: string) {
    if (!refreshToken) {
      throw new ValidationError('Refresh token não fornecido.');
    }

    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET as string);
    const usuario = await usuarioRepository.findOneBy({ id: (decoded as jwt.JwtPayload).id });

    if (!usuario || usuario.refreshToken !== refreshToken) {
      throw new ValidationError('Refresh token inválido ou expirado.');
    }

    if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
      throw new ValidationError('As variáveis JWT_SECRET ou JWT_REFRESH_SECRET não foram definidas no .env');
    }

    const newAccessToken = jwt.sign(
      { id: usuario.id, email: usuario.email },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    return newAccessToken;
  }

  async logout(refreshToken: string) {
    if (!refreshToken) {
      throw new ValidationError('Refresh token não fornecido.');
    }

    // Busca o usuário pelo refreshToken
    const usuario = await usuarioRepository.findOneBy({ refreshToken });

    // Se o usuário não for encontrado, apenas retorna uma mensagem de sucesso
    if (!usuario) {
      return 'Logout realizado com sucesso.'; // Evita lançar erro
    }

    // Remove o refreshToken do usuário e salva no banco
    usuario.refreshToken = '';
    await usuarioRepository.save(usuario);

    return 'Logout realizado com sucesso.';
  }
  
}
