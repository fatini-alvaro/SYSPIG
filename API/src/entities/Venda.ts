import { Column, CreateDateColumn, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { UsuarioFazenda } from "./UsuarioFazenda";
import { Usuario } from "./Usuario";
import { Cidade } from "./Cidade";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";
import { LoteAnimal } from "./LoteAnimal";
import { Baia } from "./Baia";
import { Lote } from "./Lote";


@Entity('venda')
export class Inseminacao {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' })
  fazenda: Fazenda;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  data_venda: Date;

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