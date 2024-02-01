import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";


@Entity('fazenda')
export class Fazenda {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'text' })
  nome: string;

}