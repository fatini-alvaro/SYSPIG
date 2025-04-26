import { Request, Response } from "express";
import { handleError } from "../utils/errorHandler";
import { DashboardService } from "../services/DashboardService";

export class DashboardController {

  private dashboardService: DashboardService;
  
  constructor() {
    this.dashboardService = new DashboardService();
  }

  list = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const dashboardData = await this.dashboardService.returnData(Number(fazenda_id));
      return res.status(200).json(dashboardData);
    } catch (error) {
      console.error("Erro ao buscar dados do Dashboard:", error);
      return handleError(error, res, "Erro ao buscar dados do Dashboard");
    }
  };
}