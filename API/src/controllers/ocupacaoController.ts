import { Request, Response } from "express";
import { AppDataSource } from "../data-source";
import { Granja } from "../entities/Granja";
import { Fazenda } from "../entities/Fazenda";
import { Baia } from "../entities/Baia";
import { Usuario } from "../entities/Usuario";
import { Animal } from "../entities/Animal";
import { Ocupacao } from "../entities/Ocupacao";
import { StatusOcupacao } from "../constants/ocupacaoConstants";
import { ocupacaoRepository } from "../repositories/ocupacaoRepository";

export class OcupacaoController {
  async create(req: Request, res: Response){
    const { 
      animal_id,
      baia_id,
      granja_id
    } = req.body;

    const fazenda_id = req.headers['fazenda-id'];
    const usuario_id = req.headers['user-id'];

    if (!fazenda_id || !usuario_id)
      return res.status(400).json({ message: 'Parametros não informado'});    

    try {

      var newOcupacao = await AppDataSource.transaction(async (transactionalEntityManager) => {

        const fazendaInstancia = await transactionalEntityManager.findOneBy( Fazenda, { id: Number(fazenda_id)});
        const usuarioInstancia = await transactionalEntityManager.findOneBy( Usuario, { id: Number(usuario_id)});
        const animalInstancia = await transactionalEntityManager.findOneBy( Animal, { id: Number(animal_id)});
        const baiaInstancia = await transactionalEntityManager.findOneBy( Baia, { id: Number(baia_id)});
        const granjaInstancia = await transactionalEntityManager.findOneBy( Granja, { id: Number(granja_id)});

        if (!fazendaInstancia)
          return res.status(404).json({ message: 'Fazenda não encontrado.' });
  
        if (!granjaInstancia)
          return res.status(404).json({ message: 'Granja não encontrado.' });

        if (!animalInstancia)
          return res.status(404).json({ message: 'Animal não encontrado.' });

        if (!usuarioInstancia)
          return res.status(404).json({ message: 'Usuário não encontrado.' });

        if (!baiaInstancia)
          return res.status(404).json({ message: 'Baia não encontrado.' });
        
        const newOcupacao = transactionalEntityManager.create(Ocupacao, {
          fazenda: fazendaInstancia,
          granja: granjaInstancia,
          animal: animalInstancia,
          baia: baiaInstancia,
          createdBy: usuarioInstancia,
          status: StatusOcupacao.ABERTA,
          dataInicio: new Date()
        });

        await transactionalEntityManager.save(newOcupacao);
        
        const savedOcupacao = await transactionalEntityManager.findOneBy(
          Ocupacao, 
          { id: newOcupacao.id },
        );
          
        //Atualiza baia
        baiaInstancia.vazia = false;
        baiaInstancia.ocupacao = savedOcupacao!;

        await transactionalEntityManager.save(baiaInstancia);

        return savedOcupacao;
      });
      
      return res.status(201).json(newOcupacao);
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao criar ocupação'});
    } 
  }

  async getById(req: Request, res: Response){
    try {      
      const { ocupacao_id } = req.params;

      const ocupacao = await ocupacaoRepository.findOne({
        where: { id: Number(ocupacao_id) }
      });

      if (!ocupacao) {
        return res.status(404).json({ message: 'Ocupação não encontrado' });
      }

      return res.status(200).json(ocupacao);
      
    } catch (error) {
      console.log(error);
      return res.status(500).json({ message: 'Erro ao buscar o ocupação'});
    }
  }


}