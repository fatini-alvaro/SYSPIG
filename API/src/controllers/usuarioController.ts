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

      if (!process.env.JWT_SECRET) {
        throw new Error('A variável JWT_SECRET não foi definida no .env');
      }      

      // Gera um token de autenticação
      const token = jwt.sign(
        { id: usuario.id, email: usuario.email },
        process.env.JWT_SECRET,
        { expiresIn: '1h' }
      );

      return res.json({
        usuario: usuario,
        token: token
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: 'Erro ao autenticar usuário' });
    }
  }

}