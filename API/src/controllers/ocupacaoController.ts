import { Request, Response } from "express";
import { OcupacaoService } from "../services/OcupacaoService";
import { handleError } from "../utils/errorHandler";
import { classToPlain } from "class-transformer";
import { ValidationError } from "../utils/validationError";

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
        return res.status(200).json(classToPlain(ocupacao)); // Atualizado
      } else {
        return res.status(201).json(classToPlain(ocupacao)); // Criado
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

  movimentarAnimais = async (req: Request, res: Response) => {
    try {
      const { movimentacoes } = req.body;
      const usuario_id = req.headers['user-id'];
      const fazenda_id = req.headers['fazenda-id'];

      if (!fazenda_id || !movimentacoes || !usuario_id) {
        return res.status(400).json({ 
          success: false,
          message: 'Parâmetros não informados' 
        });
      }

      if (!Array.isArray(movimentacoes)) {
        return res.status(400).json({ 
          success: false,
          message: 'Formato inválido, esperado array de movimentações' 
        });
      }

      const resultado = await this.ocupacaoService.movimentarAnimais({
        fazenda_id: Number(fazenda_id),
        movimentacoes: movimentacoes.map(m => ({
          animal_id: Number(m.animal_id),
          baia_destino_id: Number(m.baia_destino_id),
        })),
        usuarioIdAcao: Number(usuario_id)
      });

      return res.status(200).json(resultado);
    } catch (error) {
      console.error("Erro ao movimentar animais:", error);
      
      const message = error instanceof Error ? error.message : 'Erro ao processar movimentação';
      return res.status(400).json({
        success: false,
        message: message
      });
    }
  }
}