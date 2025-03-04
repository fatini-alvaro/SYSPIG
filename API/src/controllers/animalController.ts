import { Request, Response } from "express";
import { AnimalService } from "../services/AnimalService";
import { handleError } from "../utils/errorHandler";

export class AnimalController {

  private animalService: AnimalService;

  constructor() {
    this.animalService = new AnimalService();
  }

  list = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const animais = await this.animalService.list(Number(fazenda_id));
      return res.status(200).json(animais);
    } catch (error) {
      console.error("Erro ao listar animais:", error);
      return handleError(error, res, "Erro ao listar animais");
    }
  };

  getById = async (req: Request, res: Response) => {
    try {      
      const { animal_id } = req.params;

      const animal = await this.animalService.getById(Number(animal_id));

      if (!animal) {
        return res.status(404).json({ message: 'Animal não encontrado' });
      }

      return res.status(200).json(animal);
      
    } catch (error) {
      console.error("Erro ao buscar animal:", error);
      return handleError(error, res, "Erro ao buscar animal");
    }
  }

  delete = async (req: Request, res: Response) => {
    const animal_id = req.params.animal_id;

    if (!animal_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await this.animalService.delete(Number(animal_id));

      return res.status(200).json({ message: 'Animal excluído com sucesso' });
    } catch (error) {
      console.error("Erro ao excluir animal:", error);
      return handleError(error, res, "Erro ao excluir animal");
    }
  }

  createOrUpdate = async (req: Request, res: Response) => {
    const { numero_brinco, sexo, data_nascimento, status } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];
    const animal_id = req.params.animal_id ? Number(req.params.animal_id) : undefined;

    if (!fazenda_id || !numero_brinco || !sexo || !status) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const animalData = { 
        numero_brinco, 
        sexo, 
        data_nascimento, 
        status,
        fazenda_id: Number(fazenda_id),
        usuarioIdAcao :  Number(usuario_id)
      };

      const animal = await this.animalService.createOrUpdate(animalData, animal_id);

      if (animal_id) {
        return res.status(200).json(animal); // Atualizado
      } else {
        return res.status(201).json(animal); // Criado
      }

    } catch (error) {
      console.error("Erro ao criar/atualizar animal:", error);
      return handleError(error, res, "Erro interno ao processar animal");
    }
  };

}