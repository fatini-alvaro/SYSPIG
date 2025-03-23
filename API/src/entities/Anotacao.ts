import { Column, CreateDateColumn, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";
import { Usuario } from "./Usuario";
import { Baia } from "./Baia";
import { Ocupacao } from "./Ocupacao";

@Entity('anotacao')
export class Anotacao{
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'int', nullable: true })
  codigo: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @Column({ type: 'text' })
  descricao: string;

  @ManyToOne(() => Animal, { eager: true, nullable: true })
  @JoinColumn({ name: 'animal_id', referencedColumnName: 'id' }) 
  animal: Animal | null;

  @ManyToOne(() => Baia, { eager: true, nullable: true})
  @JoinColumn({ name: 'baia_id', referencedColumnName: 'id' }) 
  baia: Baia | null;

  @ManyToOne(() => Ocupacao, { eager: true, nullable: true})
  @JoinColumn({ name: 'ocupacao_id', referencedColumnName: 'id' }) 
  ocupacao: Ocupacao | null;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP', nullable: true })
  data: Date | null;

  @ManyToOne(() => Usuario, { eager: true, nullable: true })
  @JoinColumn({ name: 'created_by', referencedColumnName: 'id' }) 
  createdBy: Usuario | null;

  @CreateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;

  @ManyToOne(() => Usuario, { eager: true, nullable: true })
  @JoinColumn({ name: 'updated_by', referencedColumnName: 'id' }) 
  updatedBy: Usuario | null;

  @UpdateDateColumn({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updated_at: Date;
}
