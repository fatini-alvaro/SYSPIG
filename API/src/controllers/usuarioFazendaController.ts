import { Request, Response } from "express";
import { UsuarioFazendaService } from "../services/UsuarioFazendaService";
import { handleError } from "../utils/errorHandler";
import { ValidationService } from "../services/ValidationService";
import { AppDataSource } from "../data-source";

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

  create = async (req: Request, res: Response) => {
    try {  
      const { usuarioId, fazendaId } = req.body;

      if (!usuarioId || !fazendaId) {
        return res.status(400).json({ message: "Usuário e fazenda são obrigatórios." });
      }

      const usuarioInstancia = await ValidationService.validateAndReturnUsuario(usuarioId);
      const fazenda = await ValidationService.validateAndReturnFazenda(fazendaId);

      const usuarioFazenda = await this.usuarioFazendaService.createOrUpdate({
        tipo_usuario_id: usuarioInstancia?.tipoUsuario?.id ?? 0,
        usuario_id: usuarioId,
        fazenda,
      }, AppDataSource.manager);

      return res.status(201).json(usuarioFazenda);
    } catch (error) {
      console.error("Erro ao criar ou atualizar vínculo:", error);
      return handleError(error, res, "Erro ao criar ou atualizar vínculo");
    }
  };

  deleteUsuarioFazenda = async (req: Request, res: Response) => {
    try {
      const usuarioFazendaId = Number(req.params.id);
      await this.usuarioFazendaService.deleteById(usuarioFazendaId);
      res.status(204).send(); // No Content
    } catch (error: any) {
      res.status(400).json({ message: error.message || "Erro ao excluir vínculo." });
    }
  };
}