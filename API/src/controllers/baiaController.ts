import { Request, Response } from "express";
import { BaiaService } from "../services/BaiaService";
import { handleError } from "../utils/errorHandler";

export class BaiaController {

  private baiaService: BaiaService;
  
  constructor() {
    this.baiaService = new BaiaService();
  }

  createOrUpdate = async (req: Request, res: Response) => {
    const { numero, granja_id } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];
    const baia_id = req.params.baia_id ? Number(req.params.baia_id) : undefined;

    if (!fazenda_id || !numero || !usuario_id || !granja_id) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const baiaData = {
        numero,
        granja_id: Number(granja_id),
        fazenda_id: Number(fazenda_id),
        usuarioIdAcao :  Number(usuario_id)
      };

      const baia = await this.baiaService.createOrUpdate(baiaData, baia_id);

      if (baia_id) {
        return res.status(200).json(baia); // Atualizado
      } else {
        return res.status(201).json(baia); // Criado
      }

    } catch (error) {
      console.error("Erro ao criar/atualizar baia:", error);
      return handleError(error, res, "Erro interno ao processar baia");
    }
  };

  listByGranja = async (req: Request, res: Response) => {
    try {
      const { granja_id } = req.params;

      if (!granja_id)
        return res.status(400).json({ message: 'Parametros não informado'});

      const baias = await this.baiaService.listByGranja(Number(granja_id));
      return res.status(200).json(baias);
    } catch (error) {
      console.error("Erro ao listar baias:", error);
      return handleError(error, res, "Erro ao listar baias");
    }
  };

  listByFazenda = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;

      if (!fazenda_id)
        return res.status(400).json({ message: 'Parametros não informado'});

      const baias = await this.baiaService.listByFazenda(Number(fazenda_id));
      return res.status(200).json(baias);
    } catch (error) {
      console.error("Erro ao listar baias:", error);
      return handleError(error, res, "Erro ao listar baias");
    }
  };

  getById = async (req: Request, res: Response) => {
    try {      
      const { baia_id } = req.params;

      const baia = await this.baiaService.getById(Number(baia_id));

      if (!baia) {
        return res.status(404).json({ message: 'baia não encontrada' });
      }

      return res.status(200).json(baia);
      
    } catch (error) {
      console.error("Erro ao buscar baia:", error);
      return handleError(error, res, "Erro ao buscar baia");
    }
  }

  listAllOcupacoes = async (req: Request, res: Response) => {
    try {      
      const { granja_id } = req.params;

      if (!granja_id)
        return res.status(400).json({ message: 'Parametros não informado'});      

      const anotacoes = await this.baiaService.listAllOcupacoes(Number(granja_id));

      return res.status(200).json(anotacoes);
      
    } catch (error) {
      console.error("Erro ao buscar o Anotação:", error);
      return handleError(error, res, "Erro ao buscar o Anotação");
    }
  }

  delete = async (req: Request, res: Response) => {
    const baia_id = req.params.baia_id;

    if (!baia_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await this.baiaService.delete(Number(baia_id));

      return res.status(200).json({ message: 'Baia excluído com sucesso' });
    } catch (error) {
      console.error("Erro ao excluir baia:", error);
      return handleError(error, res, "Erro ao excluir baia");
    }
  }

}