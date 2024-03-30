import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";
import { Granja } from "./Granja";

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

  @Column({ type: 'boolean', default: true })
  vazia: boolean;
  
}
