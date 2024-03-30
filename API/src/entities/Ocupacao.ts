import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";
import { Granja } from "./Granja";
import { Usuario } from "./Usuario";
import { Baia } from "./Baia";

@Entity('ocupacao')
export class Ocupacao{
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'int', nullable: true })
  codigo: number;

  @Column({ type: 'text' })
  status: string;

  @ManyToOne(() => Fazenda, { eager: true, nullable: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @ManyToOne(() => Granja, { eager: true, nullable: true })
  @JoinColumn({ name: 'granja_id', referencedColumnName: 'id' }) 
  granja: Granja;

  @ManyToOne(() => Animal, { eager: true, nullable: true })
  @JoinColumn({ name: 'animal_id', referencedColumnName: 'id' }) 
  animal: Animal;
  
  @ManyToOne(() => Baia, { eager: true, nullable: true })
  @JoinColumn({ name: 'baia_id', referencedColumnName: 'id' }) 
  baia: Baia;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP', nullable: true })
  data_abertura: Date;

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
