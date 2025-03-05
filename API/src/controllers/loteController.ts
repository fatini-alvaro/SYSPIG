import { Request, Response } from "express";
import { LoteService } from "../services/LoteService";
import { handleError } from "../utils/errorHandler";

export class LoteController {

  private loteService: LoteService;
  
  constructor() {
    this.loteService = new LoteService();
  }

  createOrUpdate = async (req: Request, res: Response) => {
    const { descricao, numero_lote, lote_animais, data } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];
    const lote_id = req.params.lote_id ? Number(req.params.lote_id) : undefined;

    if (!fazenda_id || !descricao || !usuario_id) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const loteData = { 
        descricao,
        numero_lote,
        data,
        lote_animais,
        fazenda_id: Number(fazenda_id),
        usuarioIdAcao :  Number(usuario_id)
      };

      const lote = await this.loteService.createOrUpdate(loteData, lote_id);

      if (lote_id) {
        return res.status(200).json(lote); // Atualizado
      } else {
        return res.status(201).json(lote); // Criado
      }

    } catch (error) {
      console.error("Erro ao criar/atualizar lote:", error);
      return handleError(error, res, "Erro interno ao processar lote");
    }
  };

  list = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const lotes = await this.loteService.list(Number(fazenda_id));
      return res.status(200).json(lotes);
    } catch (error) {
      console.error("Erro ao listar lotes:", error);
      return handleError(error, res, "Erro ao listar lotes");
    }
  };

  getById = async (req: Request, res: Response) => {
    try {      
      const { lote_id } = req.params;

      const lote = await this.loteService.getById(Number(lote_id));

      if (!lote) {
        return res.status(404).json({ message: 'Lote não encontrado' });
      }

      return res.status(200).json(lote);      
    } catch (error) {
      console.error("Erro ao buscar lote:", error);
      return handleError(error, res, "Erro ao buscar lote");
    }
  }

  delete = async (req: Request, res: Response) => {
    const lote_id = req.params.lote_id;

    if (!lote_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await this.loteService.delete(Number(lote_id));

      return res.status(200).json({ message: 'Lote excluído com sucesso' });
    } catch (error) {
      console.error("Erro ao excluir lote:", error);
      return handleError(error, res, "Erro ao excluir lote");
    }
  }

}