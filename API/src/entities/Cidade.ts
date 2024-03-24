import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Uf } from "./Uf";
import { Fazenda } from "./Fazenda";


@Entity('cidade')
export class Cidade{
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'text' })
  nome: string;

  @ManyToOne(() => Uf, { eager: true })
  @JoinColumn({name: 'uf_id', referencedColumnName: 'id'})
  uf: Uf;

  @OneToMany(() => Fazenda, fazenda => fazenda.cidade)
  Fazendas: Fazenda[];

}