import { Request, Response } from "express";
import { fazendaRepository } from "../repositories/fazendaRepository";
import { usuarioRepository } from "../repositories/usuarioRepository";

export class FazendaController {
  async create(req: Request, res: Response){
    const { 
      nome,
      usuario_id
    } = req.body;

    if (!nome || !usuario_id)
      return res.status(400).json({ message: 'Parametros não informado'});    

    const usuarioInstancia = await usuarioRepository.findOneBy({ id: Number(usuario_id)});

    if (!usuarioInstancia)
      return res.status(404).json({ message: 'Usuário não encontrado.' });

    try {
      const newFazenda = fazendaRepository.create({
        nome: nome,
        usuario: usuarioInstancia
      });

      await fazendaRepository.save(newFazenda);

      return res.status(201).json(newFazenda);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar fazenda'});
    }
  }
}