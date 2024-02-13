import { Request, Response } from "express";
import { tipoGranjaRepository } from "../repositories/tipoGranjaRepository";

export class TipoGranjaController {
  async create(req: Request, res: Response){
    const { 
      descricao,
    } = req.body;

    if (!descricao)
      return res.status(400).json({ message: 'Parametros não informado'});    

    try {
      const newTipoGranja = tipoGranjaRepository.create({
        descricao: descricao,
      });
      await tipoGranjaRepository.save(newTipoGranja);
      return res.status(201).json(newTipoGranja);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar fazenda'});
    } 
  }

  async listAll(req: Request, res: Response){
    try {            
      const tiposGranja = await tipoGranjaRepository.find();

      return res.status(200).json(tiposGranja);      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: ''});
    }
  }
}