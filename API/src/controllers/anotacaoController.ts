import { Request, Response } from "express";
import { AnotacaoService } from "../services/AnotacaoService";
import { handleError } from "../utils/errorHandler";

export class AnotacaoController {

  private anotacaoService: AnotacaoService;

  constructor() {
    this.anotacaoService = new AnotacaoService();
  }

  createOrUpdate = async (req: Request, res: Response) => {
    const { descricao, animal_id, baia_id } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];
    const anotacao_id = req.params.anotacao_id ? Number(req.params.anotacao_id) : undefined;

    if (!fazenda_id || !descricao || !usuario_id) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const anotacaoData = { 
        descricao, 
        animal_id, 
        baia_id, 
        fazenda_id: Number(fazenda_id),
        usuarioIdAcao :  Number(usuario_id)
      };

      const anotacao = await this.anotacaoService.createOrUpdate(anotacaoData, anotacao_id);

      if (anotacao_id) {
        return res.status(200).json(anotacao); // Atualizado
      } else {
        return res.status(201).json(anotacao); // Criado
      }

    } catch (error) {
      console.error("Erro ao criar/atualizar anotação:", error);
      return handleError(error, res, "Erro interno ao processar anotação");
    }
  };

  list = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const anotacoes = await this.anotacaoService.list(Number(fazenda_id));
      return res.status(200).json(anotacoes);
    } catch (error) {
      console.error("Erro ao listar anotações:", error);
      return handleError(error, res, "Erro ao listar anotações");
    }
  };

  listByBaia = async (req: Request, res: Response) => {
    try {      
      const { baia_id } = req.params;

      if (!baia_id)
        return res.status(400).json({ message: 'Parametros não informado'});      

      const anotacoes = await this.anotacaoService.listByBaia(Number(baia_id));

      return res.status(200).json(anotacoes);
      
    } catch (error) {
      console.error("Erro ao buscar o Anotação:", error);
      return handleError(error, res, "Erro ao buscar o Anotação");
    }
  }

  delete = async (req: Request, res: Response) => {
    const anotacao_id = req.params.anotacao_id;

    if (!anotacao_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await this.anotacaoService.delete(Number(anotacao_id));

      return res.status(200).json({ message: 'Anotação excluído com sucesso' });
    } catch (error) {
      console.error("Erro ao excluir anotação:", error);
      return handleError(error, res, "Erro ao excluir anotação");
    }
  }

  getById = async (req: Request, res: Response) => {
    try {      
      const { anotacao_id } = req.params;

      const anotacao = await this.anotacaoService.getById(Number(anotacao_id));

      if (!anotacao) {
        return res.status(404).json({ message: 'Anotação não encontrada' });
      }

      return res.status(200).json(anotacao);
      
    } catch (error) {
      console.error("Erro ao buscar anotação:", error);
      return handleError(error, res, "Erro ao buscar anotação");
    }
  }

}