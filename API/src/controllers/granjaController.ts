import { Request, Response } from "express";
import { handleError } from "../utils/errorHandler";
import { GranjaService } from "../services/GranjaService";

export class GranjaController {
  private granjaService: GranjaService;

  constructor() {
    this.granjaService = new GranjaService();
  }

  createOrUpdate = async (req: Request, res: Response) => {
    const { descricao, tipo_granja_id } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];
    const granja_id = req.params.granja_id ? Number(req.params.granja_id) : undefined;

    if (!fazenda_id || !descricao || !tipo_granja_id) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const granjaData = {
        fazenda_id: Number(fazenda_id),
        tipo_granja_id: Number(tipo_granja_id),
        descricao,
        usuarioIdAcao :  Number(usuario_id)
      };

      const granja = await this.granjaService.createOrUpdate(granjaData, granja_id);

      return res.status(granja_id ? 200 : 201).json(granja);
    } catch (error) {
      console.error("Erro ao criar/atualizar granja:", error);
      return handleError(error, res, "Erro interno ao processar granja");
    }
  };

  list = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const granjas = await this.granjaService.list(Number(fazenda_id));
      return res.status(200).json(granjas);
    } catch (error) {
      console.error("Erro ao listar granjas:", error);
      return handleError(error, res, "Erro ao listar granjas");
    }
  };

  getById = async (req: Request, res: Response) => {
    try {
      const { granja_id } = req.params;
      const granja = await this.granjaService.getById(Number(granja_id));

      if (!granja) {
        return res.status(404).json({ message: 'Granja não encontrada' });
      }

      return res.status(200).json(granja);
    } catch (error) {
      console.error("Erro ao buscar granja:", error);
      return handleError(error, res, "Erro ao buscar granja");
    }
  };

  delete = async (req: Request, res: Response) => {
    const { granja_id } = req.params;

    if (!granja_id) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      await this.granjaService.delete(Number(granja_id));
      return res.status(200).json({ message: 'Granja excluída com sucesso' });
    } catch (error) {
      console.error("Erro ao excluir granja:", error);
      return handleError(error, res, "Erro ao excluir granja");
    }
  };
}