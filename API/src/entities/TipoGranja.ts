import { Column, Entity, OneToMany, PrimaryColumn } from "typeorm";
import { Granja } from "./Granja";
import { TipoGranjaId } from "../constants/tipoGranjaConstants";

@Entity('tipo_granja')
export class TipoGranja {
  @PrimaryColumn({ type: 'int' })
  id: TipoGranjaId;

  @Column({ type: 'text' })
  descricao: string;

  @OneToMany(() => Granja, granja => granja.tipoGranja)
  granjas: Granja[];
}
