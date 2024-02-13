import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Granja } from "./Granja";

@Entity('tipo_granja')
export class TipoGranja {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'text' })
  descricao: string;

  @OneToMany(() => Granja, granja => granja.tipoGranja)
  granjas: Granja[];

}