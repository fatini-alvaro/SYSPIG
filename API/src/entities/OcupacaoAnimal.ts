import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Animal } from "./Animal";
import { Usuario } from "./Usuario";
import { Ocupacao } from "./Ocupacao";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";

@Entity('ocupacao_animal')
export class OcupacaoAnimal {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Ocupacao, ocupacao => ocupacao.ocupacaoAnimais)
  @JoinColumn({ name: 'ocupacao_id' })
  ocupacao: Ocupacao;

  @ManyToOne(() => Animal, { eager: true })
  @JoinColumn({ name: 'animal_id', referencedColumnName: 'id' })
  animal: Animal;

  @ManyToOne(() => Usuario, { eager: true, nullable: true })
  @JoinColumn({ name: 'created_by', referencedColumnName: 'id' }) 
  createdBy: Usuario;

  @CreateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;

  @ManyToOne(() => Usuario, { eager: true, nullable: true })
  @JoinColumn({ name: 'updated_by', referencedColumnName: 'id' }) 
  updatedBy: Usuario;

  @UpdateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updated_at: Date;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  data_entrada: Date;

  @Column({ type: 'timestamp', nullable: true })
  data_saida: Date;

  @Column({ type: 'enum', enum: StatusOcupacaoAnimal, default: StatusOcupacaoAnimal.ATIVO })
  status: StatusOcupacaoAnimal;
}
