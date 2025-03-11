import { Request, Response } from "express";
import { TipoGranjaService } from "../services/TipoGranjaService";
import { handleError } from "../utils/errorHandler";

export class TipoGranjaController {

  private tipoGranjaService: TipoGranjaService;
    
  constructor() {
    this.tipoGranjaService = new TipoGranjaService();
  }

  listAll = async (req: Request, res: Response) => {
    try {
      const fazendas = await this.tipoGranjaService.list();
      return res.status(200).json(fazendas);
    } catch (error) {
      console.error("Erro ao listar tipo de granjas:", error);
      return handleError(error, res, "Erro ao listar tipo de granjas");
    }
  };
}