import { Request, Response } from "express";
import { handleError } from "../utils/errorHandler";
import { AuthService } from "../services/AuthService";

export class AuthController {
  private authService: AuthService;

  constructor() {
    this.authService = new AuthService();
  }

  auth = async (req: Request, res: Response) => {
    try {
      const { email, senha } = req.body;
      const authData = await this.authService.auth(email, senha);
      return res.status(200).json(authData);
    } catch (error) {
      console.error("Erro ao tentar autenticar usuario:", error);
      return handleError(error, res, "Erro ao tentar autenticar usuario");
    }
  };

  refreshToken = async (req: Request, res: Response) => {
    try {
      const { refreshToken } = req.body;
      const newAccessToken = await this.authService.refreshToken(refreshToken);
      return res.json({ accessToken: newAccessToken });
    } catch (error) {
      console.error("Erro ao dar refresh no token do usuário:", error);
      return handleError(error, res, "Erro ao dar refresh no token do usuário");
    }
  };

  logout = async (req: Request, res: Response) => {
    try {
      const { refreshToken } = req.body;
      const message = await this.authService.logout(refreshToken);
      return res.status(200).json({ message });
    } catch (error) {
      console.error("Erro ao fazer logout:", error);
      return handleError(error, res, "Erro ao fazer logout");
    }
  };
  
}