import { Request, Response } from "express";
import { loteRepository } from "../repositories/loteRepository";
import { AppDataSource } from "../data-source";
import { Fazenda } from "../entities/Fazenda";
import { Lote } from "../entities/Lote";
import { Animal } from "../entities/Animal";
import { LoteAnimal } from "../entities/LoteAnimal";

export class LoteController {

  async list(req: Request, res: Response){
    try {      
      const { fazenda_id } = req.params;

      const lotes = await loteRepository.find({ 
        where: { 
          fazenda: { 
            id: Number(fazenda_id) 
          } 
        },
        relations: ["loteAnimais"]
      });

      return res.status(200).json(lotes);
      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: ''});
    }
  }

  async create(req: Request, res: Response){
    const { 
      descricao,
      numero_lote,
      lote_animais
    } = req.body;

    const fazenda_id = req.headers['fazenda-id'];

    if (!fazenda_id || !descricao || !numero_lote)
      return res.status(400).json({ message: 'Parametros não informado'});    

    try {

      const newLote = await AppDataSource.transaction(async (transactionalEntityManager) => {

        const fazendaInstancia = await transactionalEntityManager.findOneBy( Fazenda, { id: Number(fazenda_id)});
          
        if (!fazendaInstancia)
          return res.status(404).json({ message: 'Fazenda não encontrada.' });
          
        const newLote = loteRepository.create({
          fazenda: fazendaInstancia,
          descricao: descricao,
          numero_lote: numero_lote
        });

        await transactionalEntityManager.save(newLote);

        // Adiciona as associações de lote_animal
        if (lote_animais && lote_animais.length > 0) {
          for (const loteAnimalData of lote_animais) {
            // Verifica se o animal existe
            const animal = await transactionalEntityManager.findOneBy(Animal, { id: Number(loteAnimalData.animal.id) });
            if (animal) {
              const loteAnimal = new LoteAnimal();
              loteAnimal.lote = newLote;
              loteAnimal.animal = animal;

              await transactionalEntityManager.save(loteAnimal);
            }
          }
        }
  
        return transactionalEntityManager.findOneBy(Lote, { id: newLote.id });
      });
      
      return res.status(201).json(newLote);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar lote'});
    } 
  }

  async delete(req: Request, res: Response) {
    const lote_id = req.params.lote_id;

    if (!lote_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await AppDataSource.transaction(async (transactionalEntityManager) => {
        await transactionalEntityManager.delete(LoteAnimal, { lote: { id: lote_id } });

        await transactionalEntityManager.delete(Lote, lote_id);
      });

      return res.status(200).json({ message: 'Lote excluído com sucesso' });

    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao excluir Lote' });
    }
  }

  async update(req: Request, res: Response) {
    const lote_id = req.params.lote_id;
    const { descricao, numero_lote,  lote_animais} = req.body;

    if (!descricao || !numero_lote || !lote_animais)
      return res.status(400).json({ message: 'Parametros não informado'});

    try {
      const editedLote = await AppDataSource.transaction(async (transactionalEntityManager) => {
        
        const loteToUpdate = await transactionalEntityManager.findOneBy(Lote, { id: Number(lote_id) });

        if (!loteToUpdate)
          return res.status(404).json({ message: 'Lote não encontrado' });

        loteToUpdate.descricao = descricao;
        loteToUpdate.numero_lote = numero_lote;

        await transactionalEntityManager.save(loteToUpdate);

        // Gerenciar os animais associados
        // Buscar todos os animais atualmente associados
        const existingLoteAnimais = await transactionalEntityManager.find(LoteAnimal, {
          where: { lote: { id: loteToUpdate.id } },
        });

        // Obter IDs dos animais atuais associados
        const existingAnimalIds = existingLoteAnimais.map(loteAnimal => loteAnimal.animal.id);

        // Obter IDs dos novos animais a serem associados
        const newAnimalIds = lote_animais.map((loteAnimal: { animal: { id: number } }) => loteAnimal.animal.id);

        // Encontrar animais a serem removidos
        const animalsToRemove = existingLoteAnimais.filter(loteAnimal => !newAnimalIds.includes(loteAnimal.animal.id));
        // Encontrar animais a serem adicionados
        const animalsToAdd = lote_animais.filter((loteAnimal: { animal: {id: number} }) => !existingAnimalIds.includes(loteAnimal.animal.id));

        // Remover animais que não estão mais associados
        if (animalsToRemove.length > 0) {
            await transactionalEntityManager.remove(LoteAnimal, animalsToRemove);
        }

        // Adicionar novos animais associados
        for (const loteAnimalData of animalsToAdd) {
            const animal = await transactionalEntityManager.findOneBy(Animal, { id: Number(loteAnimalData.animal.id) });
            if (animal) {
                const newLoteAnimal = new LoteAnimal();
                newLoteAnimal.lote = loteToUpdate;
                newLoteAnimal.animal = animal;
                await transactionalEntityManager.save(newLoteAnimal);
            }
        }

        return loteToUpdate;
      });

      return res.status(200).json(editedLote);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao atualizar anotação' });
    }
  }

}