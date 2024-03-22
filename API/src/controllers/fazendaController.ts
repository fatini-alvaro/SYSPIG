import { Request, Response } from "express";
import { fazendaRepository } from "../repositories/fazendaRepository";
import { usuarioRepository } from "../repositories/usuarioRepository";
import { usuarioFazendaRepository } from "../repositories/usuarioFazendaRepository";
import { tipoUsuarioRepository } from "../repositories/tipoUsuarioRepository";
import { cidadeRepository } from "../repositories/cidadeRepository";

export class FazendaController {
  async create(req: Request, res: Response){
    const { 
      nome,
      cidade_id
    } = req.body;
    
    const usuario_id = req.headers['user-id'];

    if (!nome || !usuario_id)
      return res.status(400).json({ message: 'Parametros não informado'});   

    const usuarioInstancia = await usuarioRepository.findOne({
      where: { id: Number(usuario_id) },
      relations: ['tipoUsuario'],
    });

    if (!usuarioInstancia)
      return res.status(404).json({ message: 'Usuário não encontrado.' });

    const tipoUsuarioInstancia = await tipoUsuarioRepository.findOneBy({ id: Number(usuarioInstancia.tipoUsuario.id)});    

    if (!tipoUsuarioInstancia)
      return res.status(404).json({ message: 'Tipo Usuário não encontrado.' });  

    try {

      let newFazendaData = fazendaRepository.create({
        nome: nome,
        usuario: usuarioInstancia
      });

      if (cidade_id) {
        const cidadeInstancia = await cidadeRepository.findOne({ 
          where: { id: Number(cidade_id) },
          relations: ['uf']
        });
        
        if (!cidadeInstancia) {
          return res.status(404).json({ message: 'Cidade não encontrada.' });
        }
        newFazendaData.cidade = cidadeInstancia;
      }

      await fazendaRepository.save(newFazendaData);

      const newUsuarioFazenda = usuarioFazendaRepository.create({
        tipoUsuario: tipoUsuarioInstancia,
        usuario: usuarioInstancia,
        fazenda: newFazendaData
      });

      await usuarioFazendaRepository.save(newUsuarioFazenda);

      return res.status(201).json(newFazendaData);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar fazenda'});
    } 
  }
}