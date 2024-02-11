import { Request, Response } from "express";
import { fazendaRepository } from "../repositories/fazendaRepository";
import { usuarioRepository } from "../repositories/usuarioRepository";
import { usuarioFazendaRepository } from "../repositories/usuarioFazendaRepository";
import { tipoUsuarioRepository } from "../repositories/tipoUsuarioRepository";
import { getConnection } from "typeorm";

export class FazendaController {
  async create(req: Request, res: Response){
    const { 
      nome,
      usuario_id,
      tipo_usuario_id,
    } = req.body;

    if (!nome || !usuario_id || !tipo_usuario_id )
      return res.status(400).json({ message: 'Parametros não informado'});    

    const usuarioInstancia = await usuarioRepository.findOneBy({ id: Number(usuario_id)});
    const tipoUsuarioInstancia = await tipoUsuarioRepository.findOneBy({ id: Number(tipo_usuario_id)});

    if (!usuarioInstancia)
      return res.status(404).json({ message: 'Usuário não encontrado.' });

    if (!tipoUsuarioInstancia)
      return res.status(404).json({ message: 'Tipo Usuário não encontrado.' });

    try {

      const newFazenda = fazendaRepository.create({
        nome: nome,
        usuario: usuarioInstancia
      });
      await fazendaRepository.save(newFazenda);

      const newUsuarioFazenda = usuarioFazendaRepository.create({
        tipoUsuario: tipoUsuarioInstancia,
        usuario: usuarioInstancia,
        fazenda: newFazenda
      });
      await usuarioFazendaRepository.save(newUsuarioFazenda);

      return res.status(201).json(newFazenda);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar fazenda'});
    } 
  }
}