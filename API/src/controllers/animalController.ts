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

  listLiveAndDie = async (req: Request, res: Response) => {
    try {
      const { fazenda_id } = req.params;
      const animais = await this.animalService.listLiveAndDie(Number(fazenda_id));
      return res.status(200).json(animais);
    } catch (error) {
      console.error("Erro ao listar animais vivos e mortos:", error);
      return handleError(error, res, "Erro ao listar animais  vivos e mortos");
    }
  };

  listNascimentos = async (req: Request, res: Response) => {
    try {
      const { ocupacao_id } = req.params;
      const animais = await this.animalService.listNascimentos(Number(ocupacao_id));
      return res.status(200).json(animais);
    } catch (error) {
      console.error("Erro ao listar nascimentos:", error);
      return handleError(error, res, "Erro ao listar nascimentos");
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

  deleteNascimento = async (req: Request, res: Response) => {
    const animal_id = req.params.animal_id;
    const usuario_id = req.headers['user-id'];

    if (!animal_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await this.animalService.deletarNascimento(Number(animal_id), Number(usuario_id));

      return res.status(200).json({ message: 'Nascimento excluído com sucesso' });
    } catch (error) {
      console.error("Erro ao excluir nascimento:", error);
      return handleError(error, res, "Erro ao excluir nascimento");
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

  createNascimento = async (req: Request, res: Response) => {
    const { data_nascimento, status, quantidade, baia_id } = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];

    if (!fazenda_id || !status || !quantidade || !data_nascimento || !baia_id) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {
      const nascimentoData = {
        baia_id: Number(baia_id),
        quantidade,
        status,
        data_nascimento, 
        usuarioIdAcao :  Number(usuario_id),
        fazenda_id: Number(fazenda_id),
      };

      const resultado = await this.animalService.adicionarNascimento(nascimentoData);

      return res.status(200).json(resultado);

    } catch (error) {
      console.error("Erro ao criar/atualizar animal:", error);
      return handleError(error, res, "Erro interno ao processar animal");
    }
  };

  editarStatusNascimento = async (req: Request, res: Response) => {
    const animal_id = req.params.animal_id;
    const { status} = req.body;
    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];

    if (!fazenda_id || !status || !animal_id) {
      return res.status(400).json({ message: 'Parâmetros não informados' });
    }

    try {

      const resultado = await this.animalService.editarStatusNascimento(Number(animal_id), status, Number(usuario_id));

      return res.status(200).json(resultado);

    } catch (error) {
      console.error("Erro ao editar status do nascimento:", error);
      return handleError(error, res, "Erro interno ao ao editar status do nascimento");
    }
  };

}