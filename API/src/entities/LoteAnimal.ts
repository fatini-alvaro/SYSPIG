import { Column, CreateDateColumn, Entity, JoinColumn, JoinTable, ManyToMany, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Lote } from "./Lote";
import { Animal } from "./Animal";
import { Usuario } from "./Usuario";


@Entity('lote_animal')
export class LoteAnimal {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Lote, lote => lote.loteAnimais)
  @JoinColumn({ name: 'lote_id' })
  lote: Lote;

  @ManyToOne(() => Animal, { eager: true })
  @JoinColumn({ name: 'animal_id', referencedColumnName: 'id' })
  animal: Animal;

  @Column({ type: 'boolean', default: true})
  inseminado: boolean;

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