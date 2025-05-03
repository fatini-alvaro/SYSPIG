
import { Request, Response } from "express";
import { FazendaService } from "../services/FazendaService";
import { handleError } from "../utils/errorHandler";

export class FazendaController {

  private fazendaService: FazendaService;
    
  constructor() {
    this.fazendaService = new FazendaService();
  }

  createOrUpdate = async (req: Request, res: Response) => {
    const { 
      nome,
      cidade_id
    } = req.body;
    const usuario_id = req.headers['user-id'];
    const fazenda_id = req.params.fazenda_id ? Number(req.params.fazenda_id) : undefined;

    if (!nome || !usuario_id)
      return res.status(400).json({ message: 'Parametros não informado'}); 

    try {

      const fazendaData = {
        nome,
        cidade_id,
        usuarioIdAcao: Number(usuario_id)
      };

      const newUsuario = await this.fazendaService.createOrUpdate(fazendaData, fazenda_id);

      if (fazenda_id) {
        return res.status(200).json(newUsuario); // Atualizado
      } else {
        return res.status(201).json(newUsuario); // Criado
      }

    } catch (error) {
      console.error("Erro ao criar fazenda:", error);
      return handleError(error, res, "Erro ao criar fazenda");
    }
  }

  listFazendasDisponiveis = async (req: Request, res: Response) => {
    try {
      const { usuario_id } = req.params;
      const fazendas = await this.fazendaService.listFazendasDisponiveis(Number(usuario_id));
      return res.status(200).json(fazendas);
    } catch (error) {
      console.error("Erro ao listar fazendas:", error);
      return handleError(error, res, "Erro ao listar fazendas");
    }
  };
}