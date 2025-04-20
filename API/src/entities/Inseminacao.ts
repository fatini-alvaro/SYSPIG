import { Column, CreateDateColumn, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { UsuarioFazenda } from "./UsuarioFazenda";
import { Usuario } from "./Usuario";
import { Cidade } from "./Cidade";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";
import { LoteAnimal } from "./LoteAnimal";
import { Baia } from "./Baia";
import { Lote } from "./Lote";


@Entity('inseminacao')
export class Inseminacao {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' })
  fazenda: Fazenda;

  @ManyToOne(() => Animal, { eager: true })
  @JoinColumn({ name: 'porco_doador_id', referencedColumnName: 'id' }) 
  porcoDoador: Animal;

  @ManyToOne(() => Animal, { eager: true })
  @JoinColumn({ name: 'porca_inseminada_id', referencedColumnName: 'id' }) 
  porcaInseminada: Animal;

  @ManyToOne(() => Baia, { eager: true })
  @JoinColumn({ name: 'baia_id', referencedColumnName: 'id' }) 
  baiaInseminacao: Baia;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  data: Date;

  @ManyToOne(() => Lote, { eager: true })
  @JoinColumn({ name: 'lote', referencedColumnName: 'id' })
  lote: Lote;

  @ManyToOne(() => LoteAnimal, { eager: true })
  @JoinColumn({ name: 'lote_animal', referencedColumnName: 'id' })
  loteAnimal: LoteAnimal;

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