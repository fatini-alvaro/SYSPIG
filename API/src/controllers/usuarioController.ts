import { Request, Response } from "express";
import { UsuarioService } from "../services/UsuarioService";
import { handleError } from "../utils/errorHandler";

export class UsuarioController {

  private usuarioService: UsuarioService;
  
  constructor() {
    this.usuarioService = new UsuarioService();
  }

  create = async (req: Request, res: Response) => {
    try {
      const { nome, email, senha } = req.body;
      const newUsuario = await this.usuarioService.create(nome, email, senha);
      return res.status(201).json(newUsuario);
    } catch (error) {
      console.error("Erro ao cadastrar usuario:", error);
      return handleError(error, res, "Erro ao cadastrar usuario");
    }
  }

}