import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Cidade } from "./Cidade";


@Entity('uf')
export class Uf {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'text' })
  sigla: string;

  @Column({ type: 'text' })
  nome: string;

  @OneToMany(() => Cidade, cidade => cidade.uf)
  cidades: Cidade[];

}