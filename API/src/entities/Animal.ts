import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { Usuario } from "./Usuario";
import { SexoAnimal, StatusAnimal } from "../constants/animalConstants";
import { OcupacaoAnimal } from "./OcupacaoAnimal";
import { ocupacaoAnimalRepository } from "../repositories/ocupacaoAnimalRepository";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";
import { StatusOcupacao } from "../constants/ocupacaoConstants";
import { Lote } from "./Lote";

@Entity('animal')
export class Animal {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @Column({ type: 'int', nullable: true })
  codigo: number;

  @Column({ type: 'text', nullable: true })
  numero_brinco: string;

  @Column({ type: 'text', enum: SexoAnimal, nullable: true })
  sexo: SexoAnimal;

  @Column({ type: 'enum', enum: StatusAnimal, default: StatusAnimal.VIVO })
  status: StatusAnimal;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP', nullable: true })
  data_nascimento: Date;

  @Column({ type: 'timestamp', nullable: true })
  data_ultima_inseminacao: Date;

  @ManyToOne(() => Lote, { nullable: true })
  @JoinColumn({ name: 'lote_atual_id' })
  loteAtual: Lote | null;

  @Column({ type: 'boolean', default: false})
  nascimento: boolean;

  @ManyToOne(() => Usuario, { nullable: true })
  @JoinColumn({ name: 'created_by', referencedColumnName: 'id' }) 
  createdBy: Usuario;

  @CreateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;

  @ManyToOne(() => Usuario, { nullable: true })
  @JoinColumn({ name: 'updated_by', referencedColumnName: 'id' }) 
  updatedBy: Usuario;

  @UpdateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updated_at: Date;

  async getOcupacaoAtiva(): Promise<OcupacaoAnimal | null> {
    const ocupacaoAtiva = await ocupacaoAnimalRepository.findOne({
      where: {
        animal: { id: this.id },
        status: StatusOcupacaoAnimal.ATIVO,
      },
      relations: ['ocupacao', 'ocupacao.baia']
    });
  
    return ocupacaoAtiva ?? null;
  }  
}