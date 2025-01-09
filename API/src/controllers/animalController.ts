import { Request, Response } from "express";
import { animalRepository } from "../repositories/animalRepository";
import { AppDataSource } from "../data-source";
import { Fazenda } from "../entities/Fazenda";
import { Animal } from "../entities/Animal";

export class AnimalController {

  async list(req: Request, res: Response){
    try {      
      const { fazenda_id } = req.params;

      const animais = await animalRepository.find({ 
        where: { 
          fazenda: { 
            id: Number(fazenda_id) 
          } 
        }, 
        select: ['id', 'numero_brinco'],
      });

      return res.status(200).json(animais);
      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: ''});
    }
  }

  async getById(req: Request, res: Response){
    try {      
      const { animal_id } = req.params;

      const animal = await animalRepository.findOne({
        where: { id: Number(animal_id) }
      });

      if (!animal) {
        return res.status(404).json({ message: 'Animal não encontrado' });
      }

      return res.status(200).json(animal);
      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao buscar o animal'});
    }
  }

  async create(req: Request, res: Response){
    const { 
      numeroBrinco,
      sexo,
      dataNascimento,
      status
    } = req.body;

    const fazenda_id = req.headers['fazenda-id'];

    if (!fazenda_id || !numeroBrinco || !sexo || !status)
      return res.status(400).json({ message: 'Parametros não informado'});    

    try {

      var newAnimal = await AppDataSource.transaction(async (transactionalEntityManager) => {

        const fazendaInstancia = await transactionalEntityManager.findOneBy( Fazenda, { id: Number(fazenda_id)});
  
        if (!fazendaInstancia)
          return res.status(404).json({ message: 'Fazenda não encontrado.' });
          
        const newAnimal = animalRepository.create({
          fazenda: fazendaInstancia,
          numero_brinco: numeroBrinco,
          sexo: sexo,
          data_nascimento: dataNascimento,
          status: status
        });

        await transactionalEntityManager.save(newAnimal);

        const savedAnimal = await transactionalEntityManager.findOneBy(
          Animal, 
          { id: newAnimal.id },
        );
  
        return savedAnimal;
      });
      
      return res.status(201).json(newAnimal);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar animal'});
    } 
  }

  async update(req: Request, res: Response) {
    const animal_id = req.params.animal_id;
    const { numeroBrinco, sexo,  dataNascimento, status} = req.body;

    if (!animal_id || !numeroBrinco || !sexo || !status)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      var editedAnimal = await AppDataSource.transaction(async (transactionalEntityManager) => {
        
        const animalToUpdate = await transactionalEntityManager.findOneBy(Animal, { id: Number(animal_id) });

        if (!animalToUpdate)
          return res.status(404).json({ message: 'Animal não encontrada' });

        animalToUpdate.numero_brinco = numeroBrinco;
        animalToUpdate.sexo = sexo;
        animalToUpdate.status = status;
        animalToUpdate.data_nascimento = dataNascimento;

        await transactionalEntityManager.save(animalToUpdate);

        return animalToUpdate;
      });

      return res.status(200).json(editedAnimal);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao atualizar animal' });
    }
  }

  async delete(req: Request, res: Response) {
    const animal_id = req.params.animal_id;

    if (!animal_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await AppDataSource.transaction(async (transactionalEntityManager) => {
        await transactionalEntityManager.delete(Animal, animal_id);
      });

      return res.status(200).json({ message: 'Animal excluído com sucesso' });

    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao excluir animal' });
    }
  }

}