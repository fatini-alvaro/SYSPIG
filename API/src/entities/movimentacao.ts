// src/entities/Movimentacao.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from "typeorm";
import { Animal } from "./Animal";
import { Baia } from "./Baia";
import { Usuario } from "./Usuario";
import { StatusMovimentacao, TipoMovimentacao } from "../constants/movimentacaoConstants";
import { Fazenda } from "./Fazenda";

@Entity()
export class Movimentacao {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' })
  fazenda: Fazenda;

  @ManyToOne(() => Animal)
  @JoinColumn({ name: 'animal_id' })
  animal: Animal;

  @ManyToOne(() => Baia, { nullable: true })
  @JoinColumn({ name: 'baia_origem_id' })
  baiaOrigem: Baia | null;

  @ManyToOne(() => Baia)
  @JoinColumn({ name: 'baia_destino_id' })
  baiaDestino: Baia;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  dataMovimentacao: Date;

  @Column({ type: 'enum', enum: TipoMovimentacao })
  tipo: TipoMovimentacao;

  @Column({ type: 'enum', enum: StatusMovimentacao, default: StatusMovimentacao.ATIVA })
  status: StatusMovimentacao;

  @ManyToOne(() => Usuario)
  @JoinColumn({ name: 'usuario_id' })
  usuario: Usuario;

  @Column({ type: 'text', nullable: true })
  observacoes: string | null;

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