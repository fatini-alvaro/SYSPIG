import { Request, Response } from "express";
import { AppDataSource } from "../data-source";
import { Granja } from "../entities/Granja";
import { Fazenda } from "../entities/Fazenda";
import { TipoGranja } from "../entities/TipoGranja";
import { baiaRepository } from "../repositories/baiaRepository";
import { Baia } from "../entities/Baia";
import { TabelaConstantesBancos } from "../utils/tabelaConstantesBancos";

export class BaiaController {
  async create(req: Request, res: Response){
    const { 
      numero,
      granja_id,
    } = req.body;

    const fazenda_id = req.headers['fazenda-id'];

    if (!fazenda_id || !numero || !granja_id)
      return res.status(400).json({ message: 'Parametros não informado'});    

    try {

      var newBaia = await AppDataSource.transaction(async (transactionalEntityManager) => {

        const fazendaInstancia = await transactionalEntityManager.findOneBy( Fazenda, { id: Number(fazenda_id)});
        const granjaInstancia = await transactionalEntityManager.findOneBy(Granja, { id: Number(granja_id)});
  
        if (!fazendaInstancia)
          return res.status(404).json({ message: 'Fazenda não encontrado.' });
  
        if (!granjaInstancia)
          return res.status(404).json({ message: 'Granja não encontrado.' });
        
        const newBaia = baiaRepository.create({
          fazenda: fazendaInstancia,
          numero: numero,
          granja: granjaInstancia
        });

        await transactionalEntityManager.save(newBaia);

        const savedBaia = await transactionalEntityManager.findOneBy(
          Baia, 
          { id: newBaia.id },
        );
  
        return savedBaia;
      });
      
      return res.status(201).json(newBaia);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar fazenda'});
    } 
  }

  async list(req: Request, res: Response){
    try {      
      const { granja_id } = req.params;

      const baias = await baiaRepository.find({
        where: {
          granja: {
            id: Number(granja_id),
          },
        },
        relations: ['granja', 'granja.tipoGranja', 'fazenda', 'fazenda.cidade', 'fazenda.cidade.uf', 
        'ocupacoes.granja', 'ocupacoes.granja.tipoGranja', 'ocupacoes.animal', 'ocupacoes.baia', 'ocupacoes.baia.granja',
        'ocupacoes.baia.granja.tipoGranja'],
        order: {
          numero: 'ASC'
        }
      });

      //filtra as ocupações de cada baia para retornar a ocupação ativa apenas, ou entao null
      const baiasComOcupacaoUnica = baias.map(baia => {
        const ocupacaoAtiva = baia.ocupacoes.find(ocupacao => ocupacao.status === TabelaConstantesBancos.ocupacao.ABERTA);
        return { ...baia, ocupacao: ocupacaoAtiva ? ocupacaoAtiva : null };
      });

      return res.status(200).json(baiasComOcupacaoUnica);      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: ''});
    }
  }

  async listAllOcupacoes(req: Request, res: Response){
    try {      
      const { granja_id } = req.params;

      const baias = await baiaRepository.find({ 
        where: { 
          granja: { 
            id: Number(granja_id) 
          } 
        }, 
        relations: ['granja', 'fazenda', 'fazenda.cidade', 'fazenda.cidade.uf', 'ocupacoes']
      });

      return res.status(200).json(baias);      
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