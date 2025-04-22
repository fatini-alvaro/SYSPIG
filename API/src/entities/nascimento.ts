// src/entities/Movimentacao.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from "typeorm";
import { Animal } from "./Animal";
import { Baia } from "./Baia";
import { Usuario } from "./Usuario";
import { StatusMovimentacao, TipoMovimentacao } from "../constants/movimentacaoConstants";
import { Fazenda } from "./Fazenda";
import { Lote } from "./Lote";
import { LoteAnimal } from "./LoteAnimal";

@Entity()
export class Nascimento {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' })
  fazenda: Fazenda;

  @ManyToOne(() => Animal)
  @JoinColumn({ name: 'animal_id' })
  animal: Animal;

  @ManyToOne(() => Animal)
  @JoinColumn({ name: 'matriz_id' })
  matriz: Animal;

  @ManyToOne(() => Baia, { nullable: true })
  @JoinColumn({ name: 'baia_id' })
  baia: Baia | null;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP', nullable: true })
  data_nascimento: Date;

  @ManyToOne(() => Lote, { nullable: true })
  @JoinColumn({ name: 'lote_nascimento_id' })
  loteNascimento: Lote | null;

  @ManyToOne(() => LoteAnimal, { nullable: true })
  @JoinColumn({ name: 'lote_animal_nascimento_id' })
  loteAnimalNascimento: LoteAnimal | null;

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
}