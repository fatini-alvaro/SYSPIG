import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";

@Entity('anotacao')
export class Anotacao{
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @Column({ type: 'text' })
  descricao: string;

  @ManyToOne(() => Animal, { eager: true })
  @JoinColumn({ name: 'animal_id', referencedColumnName: 'id' }) 
  animal: Animal;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  data: Date;
}
