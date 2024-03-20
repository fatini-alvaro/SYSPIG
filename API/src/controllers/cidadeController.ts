import { Request, Response } from "express";
import { cidadeRepository } from "../repositories/cidadeRepository";

export class cidadeController {
  async list(req: Request, res: Response){
    try {      

      const cidades = await cidadeRepository.find({ 
        relations: ['uf'],
        order: {
          nome: 'ASC'
        }
      });

      return res.status(200).json(cidades);
      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: ''});
    }
  }
}