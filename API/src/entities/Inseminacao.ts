import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { UsuarioFazenda } from "./UsuarioFazenda";
import { Usuario } from "./Usuario";
import { Cidade } from "./Cidade";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";


@Entity('inseminacao')
export class Inseminacao {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @Column({ type: 'int', nullable: true })
  codigo: number;

  @ManyToOne(() => Animal, { eager: true })
  @JoinColumn({ name: 'porco_doador_id', referencedColumnName: 'id' }) 
  porcoDoador: Animal;

  @ManyToOne(() => Animal, { eager: true })
  @JoinColumn({ name: 'porca_inseminada_id', referencedColumnName: 'id' }) 
  porcaInseminada: Animal;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  data: Date;
}