import { Request, Response } from "express";
import { handleError } from "../utils/errorHandler";
import { MovimentacaoService } from "../services/MovimentacaoService";

export class MovimentacaoController {

  private movimentacaoService: MovimentacaoService;

  constructor() {
    this.movimentacaoService = new MovimentacaoService();
  }

  listByFazenda = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const movimentacoes = await this.movimentacaoService.listByFazenda(Number(fazenda_id));
      return res.status(200).json(movimentacoes);
    } catch (error) {
      console.error("Erro ao listar movimentacoes:", error);
      return handleError(error, res, "Erro ao listar movimentacoes");
    }
  };

}