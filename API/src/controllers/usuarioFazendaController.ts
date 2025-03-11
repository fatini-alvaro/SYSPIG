import { Request, Response } from "express";
import { UsuarioFazendaService } from "../services/UsuarioFazendaService";
import { handleError } from "../utils/errorHandler";

export class UsuarioFazendaController {

  private usuarioFazendaService: UsuarioFazendaService;
  
  constructor() {
    this.usuarioFazendaService = new UsuarioFazendaService();
  }

  listFazendas = async (req: Request, res: Response) => {
    try {
      const { usuario_id } = req.params;
      const fazendas = await this.usuarioFazendaService.listFazendas(Number(usuario_id));
      return res.status(200).json(fazendas);
    } catch (error) {
      console.error("Erro ao listar anotações:", error);
      return handleError(error, res, "Erro ao listar anotações");
    }
  };
}