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
      const { nome, email, senha, tipoUsuarioId, criadoPor } = req.body;
      const newUsuario = await this.usuarioService.create(nome, email, senha, tipoUsuarioId, criadoPor);
      return res.status(201).json(newUsuario);
    } catch (error) {
      console.error("Erro ao cadastrar usuario:", error);
      return handleError(error, res, "Erro ao cadastrar usuario");
    }
  }

  update = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const { nome, email } = req.body;
      const updatedUsuario = await this.usuarioService.update(Number(id), { nome, email });
      return res.status(200).json(updatedUsuario);
    } catch (error) {
      console.error("Erro ao atualizar usuario:", error);
      return handleError(error, res, "Erro ao atualizar usuario");
    }
  }

  listByFazenda = async (req: Request, res: Response) => {
    try {
      const {fazenda_id} = req.params;
      const usuarioId = req.query.usuarioId
      const usuarios = await this.usuarioService.listByFazenda(Number(fazenda_id), Number(usuarioId));
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

  changeUsuarioPassword = async (req: Request, res: Response) => {
    try {
      const userId = Number(req.params.id);
      const { senhaAtual, novaSenha } = req.body;
  
      const result = await this.usuarioService.changePassword(userId, senhaAtual, novaSenha);
      res.json(result);
    } catch (error: any) {
      res.status(400).json({ message: error.message || 'Erro ao alterar senha.' });
    }
  }

}