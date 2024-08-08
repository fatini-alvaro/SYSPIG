import { Column, CreateDateColumn, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Uf } from "./Uf";
import { Fazenda } from "./Fazenda";
import { Usuario } from "./Usuario";


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