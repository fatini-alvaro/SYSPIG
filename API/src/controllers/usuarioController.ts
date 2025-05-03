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

  listByFazenda = async (req: Request, res: Response) => {
    try {
      const {fazenda_id} = req.params;
      const usuarios = await this.usuarioService.listByFazenda(Number(fazenda_id));
      return res.status(200).json(usuarios);
    } catch (error) {
      console.error("Erro ao listar usuarios:", error);
      return handleError(error, res, "Erro ao listar usuarios");
    }
  }

  getPerfilUsuario = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const usuario = await this.usuarioService.getPerfilUsuario(Number(id));
      return res.status(200).json(usuario);
    } catch (error) {
      console.error("Erro ao obter perfil do usuario:", error);
      return handleError(error, res, "Erro ao obter perfil do usuario");
    }
  }

}