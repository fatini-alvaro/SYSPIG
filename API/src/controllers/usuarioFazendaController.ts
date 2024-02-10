import { Request, Response } from "express";
import { tipoUsuarioRepository } from "../repositories/tipoUsuarioRepository";
import { usuarioRepository } from "../repositories/usuarioRepository";
import { fazendaRepository } from "../repositories/fazendaRepository";
import { usuarioFazendaRepository } from "../repositories/usuarioFazendaRepository";

export class UsuarioFazendaController {

  async create(req: Request, res: Response){
    const { 
      tipo_usuario_id,
      usuario_id,
      fazenda_id
    } = req.body;

    if (!tipo_usuario_id || !usuario_id || !fazenda_id)
      return res.status(400).json({ message: 'Parametros não informado'}); 
    
    const tipoUsuarioInstancia = await tipoUsuarioRepository.findOneBy({ id: Number(tipo_usuario_id)});
    const usuarioInstancia = await usuarioRepository.findOneBy({ id: Number(usuario_id)});
    const fazendaInstancia = await fazendaRepository.findOneBy({ id: Number(fazenda_id)});

    if (!tipoUsuarioInstancia)
      return res.status(404).json({ message: 'Tipo Usuário não encontrado.' });

    if (!usuarioInstancia)
      return res.status(404).json({ message: 'Usuário não encontrado.' });

    if (!fazendaInstancia)
      return res.status(404).json({ message: 'Fazenda não encontrada.' });

    try {
      const newUsuarioFazenda = usuarioFazendaRepository.create({
        tipoUsuario: tipoUsuarioInstancia,
        usuario: usuarioInstancia,
        fazenda: fazendaInstancia
      });

      await usuarioFazendaRepository.save(newUsuarioFazenda);

      return res.status(201).json(newUsuarioFazenda);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar Usuario Fazenda'});
    }
  }

}