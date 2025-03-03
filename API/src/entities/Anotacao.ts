import { Column, CreateDateColumn, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";
import { Usuario } from "./Usuario";
import { Baia } from "./Baia";

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

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  data: Date;

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
