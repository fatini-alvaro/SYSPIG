import { Request, Response } from "express";
import { anotacaoRepository } from "../repositories/anotacaoRepository";
import { AppDataSource } from "../data-source";
import { Fazenda } from "../entities/Fazenda";
import { Animal } from "../entities/Animal";
import { Anotacao } from "../entities/Anotacao";
import { Baia } from "../entities/Baia";

export class AnotacaoController {
  async create(req: Request, res: Response){
    const { 
      descricao,
      animal_id,
      baia_id
    } = req.body;

    const fazenda_id = req.headers['fazenda-id'];

    if (!fazenda_id || !descricao)
      return res.status(400).json({ message: 'Parametros não informado'});    

    try {

      var newAnotacao = await AppDataSource.transaction(async (transactionalEntityManager) => {

        const fazendaInstancia = await transactionalEntityManager.findOneBy( Fazenda, { id: Number(fazenda_id)});
          
        if (!fazendaInstancia)
          return res.status(404).json({ message: 'Fazenda não encontrado.' });
          
        const newAnotacao = anotacaoRepository.create({
          fazenda: fazendaInstancia,
          descricao: descricao,
          animal: animal_id,
          baia: baia_id
        });

        await transactionalEntityManager.save(newAnotacao);

        const savedAnotacao = await transactionalEntityManager.findOneBy(
          Anotacao, 
          { id: newAnotacao.id },
        );
  
        return savedAnotacao;
      });
      
      return res.status(201).json(newAnotacao);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar anotação'});
    } 
  }

  async list(req: Request, res: Response){
    try {      
      const { fazenda_id } = req.params;

      const anotacoes = await anotacaoRepository.find({ 
        where: { 
          fazenda: { 
            id: Number(fazenda_id) 
          } 
        }
      });

      return res.status(200).json(anotacoes);
      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: ''});
    }
  }

  async listByBaia(req: Request, res: Response){

    const { 
      baia_id,
    } = req.body;

    if (!baia_id)
      return res.status(400).json({ message: 'Parametros não informado'});    

    try {      

      const anotacoes = await anotacaoRepository.find({
        where: {
          baia: {
            id: Number(baia_id),
          },
        },
        order: {
          data: 'DESC'
        }
      });

      return res.status(200).json(anotacoes);      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: ''});
    }
  }

  async update(req: Request, res: Response) {
    const anotacao_id = req.params.anotacao_id;
    const { descricao, animal_id,  baia_id} = req.body;

    if (!descricao)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      const editedAnotacao = await AppDataSource.transaction(async (transactionalEntityManager) => {
        
        const anotacaoToUpdate = await transactionalEntityManager.findOneBy(Anotacao, { id: Number(anotacao_id) });

        if (!anotacaoToUpdate)
          return res.status(404).json({ message: 'Anotacao não encontrada' });

        const animalInstancia = await transactionalEntityManager.findOneBy(Animal, { id: Number(animal_id) });
        const baiaInstancia = await transactionalEntityManager.findOneBy(Baia, { id: Number(baia_id) });

        anotacaoToUpdate.descricao = descricao;
        anotacaoToUpdate.animal = animalInstancia;
        anotacaoToUpdate.baia = baiaInstancia;

        await transactionalEntityManager.save(anotacaoToUpdate);

        return anotacaoToUpdate;
      });

      return res.status(200).json(editedAnotacao);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao atualizar anotação' });
    }
  }

  async delete(req: Request, res: Response) {
    const anotacao_id = req.params.anotacao_id;

    if (!anotacao_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await AppDataSource.transaction(async (transactionalEntityManager) => {
        await transactionalEntityManager.delete(Anotacao, anotacao_id);
      });

      return res.status(200).json({ message: 'Anotação excluído com sucesso' });

    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao excluir Anotação' });
    }
  }

}