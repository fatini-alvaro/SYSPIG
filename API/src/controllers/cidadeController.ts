import { Request, Response } from "express";
import { CidadeService } from "../services/CidadeService";
import { handleError } from "../utils/errorHandler";

export class CidadeController {
  private cidadeService: CidadeService;
      
  constructor() {
    this.cidadeService = new CidadeService();
  }

  list = async (req: Request, res: Response) => {
    try {
      const cidades = await this.cidadeService.list();
      return res.status(200).json(cidades);
    } catch (error) {
      console.error("Erro ao listar cidades:", error);
      return handleError(error, res, "Erro ao listar cidades");
    }
    };
}