import { Request, Response } from "express";
import { usuarioRepository } from "../repositories/usuarioRepository";
import { tipoUsuarioRepository } from "../repositories/tipoUsuarioRepository";

export class UsuarioController {
  async create(req: Request, res: Response){
    const {
      nome,
      email,
      senha,
      tipo_usuario_id
    } = req.body;

    if (!nome || !email || !senha || !tipo_usuario_id)
      return res.status(400).json({ message: 'Todos os campos são obrigatórios.' });
    

    // Obtém a instância do TipoUsuario com base no ID
    const tipoUsuarioInstancia = await tipoUsuarioRepository.findOneBy({ id: Number(tipo_usuario_id)});

    if (!tipoUsuarioInstancia)
      return res.status(404).json({ message: 'Tipo de usuário não encontrado.' });

    try {
      const newUsuario = await usuarioRepository.create({
        nome: nome,
        email:email,
        senha: senha,
        tipoUsuario: tipoUsuarioInstancia
      });

      await usuarioRepository.save(newUsuario);

      console.log(newUsuario);
      return res.status(201).json(newUsuario);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar usuário'});
    }
    
  }

  async auth(req: Request, res: Response){
    const { 
      email,
      senha
    } = req.body;

    try {

      if (!email || !senha)
        return res.status(400).json({ message: 'Parametros não informado'}); 

      const usuario = await usuarioRepository.findOne({ 
        where: {
          email: email,
          senha: senha,
        }, 
        relations: ['tipoUsuario']
      });

      if (!usuario)
        return res.status(400).json({ message: 'Usuário não encontrado'}); 
    
      return res.status(201).json(usuario);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar buscar Usuario'});
    }
  }

}