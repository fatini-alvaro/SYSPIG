import { Request, Response } from "express";
import { handleError } from "../utils/errorHandler";
import { InseminacaoService } from "../services/InseminacaoService";

export class InseminacaoController {

  private inseminacaoService: InseminacaoService;

  constructor() {
    this.inseminacaoService = new InseminacaoService();
  }

  list = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      
    } catch (error) {
      console.error("Erro ao listar animais:", error);
      return handleError(error, res, "Erro ao listar animais");
    }
  };

}