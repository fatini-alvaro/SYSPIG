import { Request, Response } from "express";
import { OcupacaoService } from "../services/OcupacaoService";
import { handleError } from "../utils/errorHandler";

export class OcupacaoController {

  private ocupacaoService: OcupacaoService;
    
  constructor() {
    this.ocupacaoService = new OcupacaoService();
  }

  list = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const ocupacoes = await this.ocupacaoService.list(Number(fazenda_id));
      return res.status(200).json(ocupacoes);
    } catch (error) {
      console.error("Erro ao listar ocupacoes:", error);
      return handleError(error, res, "Erro ao listar ocupacoes");
    }
  };

  createOrUpdate = async (req: Request, res: Response) => {
    const { baia_id, status, ocupacao_animais } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];
    const ocupacao_id = req.params.ocupacao_id ? Number(req.params.ocupacao_id) : undefined;

    if (!fazenda_id || !baia_id || !status || !usuario_id) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const ocupacaoData = { 
        fazenda_id: Number(fazenda_id),
        baia_id: Number(baia_id),
        status: Number(status),
        ocupacao_animais,
        usuarioIdAcao: Number(usuario_id)
      };

      const ocupacao = await this.ocupacaoService.createOrUpdate(ocupacaoData, ocupacao_id);

      if (ocupacao_id) {
        return res.status(200).json(ocupacao); // Atualizado
      } else {
        return res.status(201).json(ocupacao); // Criado
      }

    } catch (error) {
      console.error("Erro ao criar/atualizar Ocupação:", error);
      return handleError(error, res, "Erro interno ao processar Ocupação");
    }
  }

  getById = async (req: Request, res: Response) => {
    try {      
      const { ocupacao_id } = req.params;

      const ocupacao = await this.ocupacaoService.getById(Number(ocupacao_id));

      if (!ocupacao) {
        return res.status(404).json({ message: 'Ocupação não encontrado' });
      }

      return res.status(200).json(ocupacao);      
    } catch (error) {
      console.error("Erro ao buscar Ocupação:", error);
      return handleError(error, res, "Erro ao buscar Ocupação");
    }
  }

  getByBaiaId = async (req: Request, res: Response) => {
    try {      
      const { baia_id } = req.params;

      const ocupacao = await this.ocupacaoService.getByBaiaId(Number(baia_id));

      if (!ocupacao) {
        return res.status(404).json({ message: 'Ocupação não encontrado' });
      }

      return res.status(200).json(ocupacao);      
    } catch (error) {
      console.error("Erro ao buscar Ocupação:", error);
      return handleError(error, res, "Erro ao buscar Ocupação");
    }
  }

}