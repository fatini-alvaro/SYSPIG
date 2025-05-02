import { Request, Response } from "express";
import { handleError } from "../utils/errorHandler";
import { VendaService } from "../services/VendaService";

export class VendaController {

  private vendaService: VendaService;

  constructor() {
    this.vendaService = new VendaService();
  }

  list = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const vendas = await this.vendaService.list(Number(fazenda_id));
      return res.status(200).json(vendas);
    } catch (error) {
      console.error("Erro ao listar vendas:", error);
      return handleError(error, res, "Erro ao listar vendas");
    }
  };

  createVenda = async (req: Request, res: Response) => {
    const { data_venda, quantidade, valor_venda, peso, animais } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];

    if (!fazenda_id  || !quantidade || !data_venda || !valor_venda || !animais) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const vendaData = {
        peso: Number(peso),
        valor_venda: Number(valor_venda),
        quantidade: Number(quantidade),
        data_venda: new Date(data_venda),
        usuarioIdAcao :  Number(usuario_id),
        animais: animais,
        fazenda_id: Number(fazenda_id),
      };

      const resultado = await this.vendaService.create(vendaData);

      return res.status(200).json(resultado);

    } catch (error) {
      console.error("Erro ao criar venda:", error);
      return handleError(error, res, "Erro interno ao processar venda");
    }
  };
}