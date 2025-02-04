import { Request, Response } from "express";
import { AnimalService } from "../services/AnimalService";

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
      console.error(error);
      return res.status(500).json({ message: 'Erro ao listar animais' });
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
      console.log(error);
      return res.status(500).json({ message: 'Erro ao buscar o animal'});
    }
  }

  delete = async (req: Request, res: Response) => {
    const animal_id = req.params.animal_id;

    if (!animal_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await this.animalService.deleteAnimal(Number(animal_id));

      return res.status(200).json({ message: 'Animal excluído com sucesso' });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao excluir animal' });
    }
  }

  createOrUpdate = async (req: Request, res: Response) => {
    const { numeroBrinco, sexo, dataNascimento, status } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const animal_id = req.params.animal_id ? Number(req.params.animal_id) : undefined;

    if (!fazenda_id || !numeroBrinco || !sexo || !status) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const animalData = { numeroBrinco, sexo, dataNascimento, status };
      const animal = await this.animalService.createOrUpdate(Number(fazenda_id), animalData, animal_id);

      if (animal_id) {
        return res.status(200).json(animal); // Atualizado
      } else {
        return res.status(201).json(animal); // Criado
      }

    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: 'Erro ao processar animal' });
    }
  };

}