import { Column, CreateDateColumn, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { Granja } from "./Granja";
import { Usuario } from "./Usuario";
import { Ocupacao } from "./Ocupacao";

@Entity('baia')
export class Baia{
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'int', nullable: true })
  codigo: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @ManyToOne(() => Granja, { eager: true })
  @JoinColumn({ name: 'granja_id', referencedColumnName: 'id' }) 
  granja: Granja;

  @Column({ type: 'text' })
  numero: string;

  @Column({ type: 'integer', nullable: true})
  capacidade: number;

  @Column({ type: 'boolean', default: true})
  vazia: boolean;

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
  
  @OneToMany(() => Ocupacao, ocupacao => ocupacao.baia)
  ocupacoes: Ocupacao[]; 
}
