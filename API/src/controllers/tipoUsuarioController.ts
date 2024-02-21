import { Request, Response } from "express";
import { tipoUsuarioRepository } from "../repositories/tipoUsuarioRepository";

export class TipoUsuarioController {
  async create(req: Request, res: Response){
    const { 
      descricao 
    } = req.body;

    if (!descricao)
      return res.status(400).json({ message: 'Parametros faltantes'});  
      
    try {
      const newTipoUsuario = tipoUsuarioRepository.create({ 
        descricao: descricao
      });

      await tipoUsuarioRepository.save(newTipoUsuario);

      return res.status(201).json(newTipoUsuario);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar Tipo Usuario' });
    }
  }
}