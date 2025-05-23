import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Fazenda } from "./Fazenda";
import { Animal } from "./Animal";
import { Granja } from "./Granja";
import { Usuario } from "./Usuario";
import { Baia } from "./Baia";
import { OcupacaoAnimal } from "./OcupacaoAnimal";
import { Anotacao } from "./Anotacao";
import { StatusOcupacao } from "../constants/ocupacaoConstants";
import { Exclude } from "class-transformer";
import { StatusOcupacaoAnimal } from "../constants/ocupacaoAnimalConstants";

@Entity('ocupacao')
export class Ocupacao {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'int', nullable: true })
  codigo: number;

  @Column({ type: 'enum', enum: StatusOcupacao, default: StatusOcupacao.ABERTA })
  status: StatusOcupacao;

  @ManyToOne(() => Fazenda, { eager: true, nullable: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' }) 
  fazenda: Fazenda;

  @ManyToOne(() => Granja, { eager: true, nullable: true })
  @JoinColumn({ name: 'granja_id', referencedColumnName: 'id' }) 
  granja: Granja;

  @ManyToOne(() => Animal, { eager: true, nullable: true })
  @JoinColumn({ name: 'animal_id', referencedColumnName: 'id' }) 
  animal: Animal;
  
  @ManyToOne(() => Baia, { eager: true, nullable: true })
  @JoinColumn({ name: 'baia_id', referencedColumnName: 'id' }) 
  @Exclude()
  baia: Baia;

  // Todas as ocupações animais (histórico completo)
  @OneToMany(() => OcupacaoAnimal, ocupacaoAnimal => ocupacaoAnimal.ocupacao)
  ocupacaoAnimais: OcupacaoAnimal[];

  // Método para obter apenas as ocupações ativas
  get ocupacaoAnimaisAtivas(): OcupacaoAnimal[] {
    return this.ocupacaoAnimais?.filter(oa => oa.status === StatusOcupacaoAnimal.ATIVO) || [];
  }

  @OneToMany(() => Anotacao, anotacao => anotacao.ocupacao)
  anotacoes: Anotacao[];

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP', nullable: true })
  data_abertura: Date;

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