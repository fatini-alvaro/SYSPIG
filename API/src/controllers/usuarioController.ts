import { Request, Response } from "express";
import { usuarioRepository } from "../repositories/usuarioRepository";
import { tipoUsuarioRepository } from "../repositories/tipoUsuarioRepository";
import { TipoUsuarioId } from "../constants/tipoUsuarioConstants";
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export class UsuarioController {
  async create(req: Request, res: Response){
    const {
      nome,
      email,
      senha
    } = req.body;

    const tipo_usuario_dono_id = TipoUsuarioId.DONO;

    if (!nome || !email || !senha)
      return res.status(400).json({ message: 'Todos os campos são obrigatórios.' });
    
    try {

      // Verifica se o e-mail já está cadastrado
      const existingUsuario = await usuarioRepository.findOneBy({ email });
      if (existingUsuario) {
        return res.status(409).json({ message: 'O e-mail já está em uso.' });
      }

      const tipoUsuarioInstancia = await tipoUsuarioRepository.findOneBy({ id: Number(tipo_usuario_dono_id)});  
      if (!tipoUsuarioInstancia)
        return res.status(404).json({ message: 'Tipo de usuário não encontrado.' });

      // Criptografa a senha
      const hashedPassword = await bcrypt.hash(senha, 10);

      const newUsuario = usuarioRepository.create({
        nome: nome,
        email:email,
        senha: hashedPassword,
        tipoUsuario: tipoUsuarioInstancia
      });

      await usuarioRepository.save(newUsuario);

      return res.status(201).json(newUsuario);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar usuário'});
    }
    
  }

  async auth(req: Request, res: Response) {
    const { email, senha } = req.body;

    try {
      const usuario = await usuarioRepository.findOneBy({ email });
      if (!usuario) {
        return res.status(404).json({ message: 'Usuário não encontrado' });
      }

      // Verifica se a senha está correta
      const isPasswordValid = await bcrypt.compare(senha, usuario.senha);
      if (!isPasswordValid) {
        return res.status(401).json({ message: 'Credenciais inválidas' });
      }

      if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
        throw new Error('As variáveis JWT_SECRET ou JWT_REFRESH_SECRET não foram definidas no .env');
      }

      // Gera um refresh token
      const refreshToken = jwt.sign(
        { id: usuario.id, email: usuario.email },
        process.env.JWT_REFRESH_SECRET,
        { expiresIn: '7d' } // Expiração de 7 dias
      );

      // Armazena o refresh token no banco de dados
      usuario.refreshToken = refreshToken;
      await usuarioRepository.save(usuario);

      // Gera um token de autenticação
      const accessToken = jwt.sign(
        { id: usuario.id, email: usuario.email },
        process.env.JWT_SECRET,
        { expiresIn: '1h' }
      );

      return res.json({
        usuario,
        accessToken,
        refreshToken,
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: 'Erro ao autenticar usuário' });
    }
  }

  async refreshToken(req: Request, res: Response) {
    const { refreshToken } = req.body;
  
    if (!refreshToken) {
      return res.status(400).json({ message: 'Refresh token não fornecido.' });
    }
  
    try {
      // Verifica o refresh token
      const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET as string);
  
      // Verifica se o refresh token está armazenado no banco de dados
      const usuario = await usuarioRepository.findOneBy({ id: (decoded as jwt.JwtPayload).id });
      if (!usuario || usuario.refreshToken !== refreshToken) {
        return res.status(403).json({ message: 'Refresh token inválido ou expirado.' });
      }

      if (!process.env.JWT_SECRET || !process.env.JWT_REFRESH_SECRET) {
        throw new Error('As variáveis JWT_SECRET ou JWT_REFRESH_SECRET não foram definidas no .env');
      }
  
      // Gera um novo access token
      const newAccessToken = jwt.sign(
        { id: usuario.id, email: usuario.email },
        process.env.JWT_SECRET,
        { expiresIn: '1h' }
      );
  
      return res.json({ accessToken: newAccessToken });
    } catch (error: any) {

      if (error.name === 'TokenExpiredError') {
        return res.status(403).json({ message: 'Refresh token expirado. Faça login novamente.' });
      }

      console.error(error);
      return res.status(403).json({ message: 'Token inválido ou expirado.' });
    }
  }
  
  async logout(req: Request, res: Response) {
    const { refreshToken } = req.body;
  
    if (!refreshToken) {
      return res.status(400).json({ message: 'Refresh token não fornecido.' });
    }
  
    try {
      const usuario = await usuarioRepository.findOneBy({ refreshToken });
      if (!usuario) {
        return res.status(404).json({ message: 'Usuário não encontrado.' });
      }
  
      // Invalida o refresh token
      usuario.refreshToken = '';
      await usuarioRepository.save(usuario);
  
      return res.status(200).json({ message: 'Logout realizado com sucesso.' });
    } catch (error) {
      console.error('Erro ao realizar logout:', error);
      return res.status(500).json({ message: 'Erro ao realizar logout.' });
    }
  }  
  

}