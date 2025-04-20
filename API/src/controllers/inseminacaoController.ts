import { Request, Response } from "express";
import { handleError } from "../utils/errorHandler";
import { InseminacaoService } from "../services/InseminacaoService";

export class InseminacaoController {

  private inseminacaoService: InseminacaoService;

  constructor() {
    this.inseminacaoService = new InseminacaoService();
  }

  listByFazenda = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const inseminacoes = await this.inseminacaoService.listByFazenda(Number(fazenda_id));
      return res.status(200).json(inseminacoes);
    } catch (error) {
      console.error("Erro ao listar inseminacoes:", error);
      return handleError(error, res, "Erro ao listar inseminacoes");
    }
  };

  inseminarAnimais = async (req: Request, res: Response) => {
    try {
      const { inseminacoes } = req.body;
      const usuario_id = req.headers['user-id'];
      const fazenda_id = req.headers['fazenda-id'];

      if (!fazenda_id || !inseminacoes || !usuario_id) {
        return res.status(400).json({ 
          success: false,
          message: 'Parâmetros não informados' 
        });
      }

      if (!Array.isArray(inseminacoes)) {
        return res.status(400).json({ 
          success: false,
          message: 'Formato inválido, esperado array de inseminações' 
        });
      }

      const resultado = await this.inseminacaoService.inseminarAnimais({
        fazenda_id: Number(fazenda_id),
        usuarioIdAcao: Number(usuario_id),
        inseminacoes: inseminacoes.map(m => ({
          porca_inseminada_id: Number(m.porca_inseminada_id),
          porco_doador_id: Number(m.porco_doador_id),
          lote_animal_id: Number(m.lote_animal_id),
          baia_id: Number(m.baia_id),
          lote_id: Number(m.lote_id),
          data: new Date(m.data),
        })),
      });

      return res.status(200).json(resultado);
    } catch (error) {
      console.error("Erro ao isneminar animais:", error);
      
      const message = error instanceof Error ? error.message : 'Erro ao processar inseminações';
      return res.status(400).json({
        success: false,
        message: message
      });
    }
  }

}