import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { TipoGranja } from "./TipoGranja";

@Entity('granja')
export class Granja {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true }) // Muitas granjas podem pertencer a uma fazenda
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @Column({ type: 'int', nullable: true })
  codigo: number;

  @ManyToOne(() => TipoGranja, { eager: true })
  @JoinColumn({ name: 'tipo_granja_id', referencedColumnName: 'id' }) 
  tipoGranja: TipoGranja;

  @Column({ type: 'text' })
  descricao: string;
}