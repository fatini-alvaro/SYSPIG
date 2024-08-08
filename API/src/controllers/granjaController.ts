import { Request, Response } from "express";
import { fazendaRepository } from "../repositories/fazendaRepository";
import { tipoGranjaRepository } from "../repositories/tipoGranjaRepository";
import { granjaRepository } from "../repositories/granjaRepository";
import { AppDataSource } from "../data-source";
import { Granja } from "../entities/Granja";
import { Fazenda } from "../entities/Fazenda";
import { TipoGranja } from "../entities/TipoGranja";

export class GranjaController {
  async create(req: Request, res: Response){
    const { 
      descricao,
      tipo_granja_id,
    } = req.body;

    const fazenda_id = req.headers['fazenda-id'];

    if (!fazenda_id || !descricao || !tipo_granja_id)
      return res.status(400).json({ message: 'Parametros não informado'});    

    try {

      var newGranja = await AppDataSource.transaction(async (transactionalEntityManager) => {

        const fazendaInstancia = await transactionalEntityManager.findOneBy( Fazenda, { id: Number(fazenda_id)});
        const tipoGranjaInstancia = await transactionalEntityManager.findOneBy(TipoGranja, { id: Number(tipo_granja_id)});
  
        if (!fazendaInstancia)
          return res.status(404).json({ message: 'Fazenda não encontrado.' });
  
        if (!tipoGranjaInstancia)
          return res.status(404).json({ message: 'Tipo Granja não encontrado.' });
        
        const newGranja = granjaRepository.create({
          fazenda: fazendaInstancia,
          descricao: descricao,
          tipoGranja: tipoGranjaInstancia
        });

        await transactionalEntityManager.save(newGranja);

        const savedGranja = await transactionalEntityManager.findOneBy(
          Granja, 
          { id: newGranja.id },
        );
  
        return savedGranja;
      });
      
      return res.status(201).json(newGranja);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar granja'});
    } 
  }

  async list(req: Request, res: Response){
    try {      
      const { fazenda_id } = req.params;

      const granjas = await granjaRepository.find({ 
        where: { 
          fazenda: { 
            id: Number(fazenda_id) 
          } 
        }, 
        relations: ['tipoGranja', 'fazenda', 'fazenda.cidade', 'fazenda.cidade.uf']
      });

      return res.status(200).json(granjas);
      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: ''});
    }
  }

  async update(req: Request, res: Response) {
    const granja_id = req.params.granja_id;
    const { descricao, tipo_granja_id } = req.body;
    const fazenda_id = req.headers['fazenda-id'];

    if (!granja_id || !descricao || !tipo_granja_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      var newGranja = await AppDataSource.transaction(async (transactionalEntityManager) => {
        
        const granjaToUpdate = await transactionalEntityManager.findOneBy(Granja, { id: Number(granja_id) });

        if (!granjaToUpdate)
          return res.status(404).json({ message: 'Granja não encontrada' });

        const fazendaInstancia = await transactionalEntityManager.findOneBy(Fazenda, { id: Number(fazenda_id) });

        if (!fazendaInstancia)
          return res.status(404).json({ message: 'Fazenda não encontrada' });

        const tipoGranjaInstancia = await transactionalEntityManager.findOneBy(TipoGranja, { id: Number(tipo_granja_id) });

        if (!tipoGranjaInstancia)
          return res.status(404).json({ message: 'Tipo Granja não encontrado' });

        granjaToUpdate.descricao = descricao;
        granjaToUpdate.tipoGranja = tipoGranjaInstancia;
        granjaToUpdate.fazenda = fazendaInstancia;

        await transactionalEntityManager.save(granjaToUpdate);

        return granjaToUpdate;
      });

      return res.status(200).json(newGranja);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao atualizar granja' });
    }
  }

  async delete(req: Request, res: Response) {
    const granja_id = req.params.granja_id;

    if (!granja_id)
      return res.status(400).json({ message: 'Parâmetros não informados' });

    try {
      await AppDataSource.transaction(async (transactionalEntityManager) => {
        await transactionalEntityManager.delete(Granja, granja_id);
      });

      return res.status(200).json({ message: 'Granja excluída com sucesso' });

    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao excluir granja' });
    }
  }

}