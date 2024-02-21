import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Fazenda } from "./Fazenda";

@Entity('animal')
export class Animal{
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @Column({ type: 'text' })
  numero_brinco: string;
  
  @Column({ type: 'text' })
  sexo: string;

  @Column({ type: 'text' })
  status: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  data_nascimento: Date;
}
