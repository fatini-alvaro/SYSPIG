import { Column, CreateDateColumn, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Usuario } from "./Usuario";
import { Fazenda } from "./Fazenda";


@Entity('venda')
export class Venda {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Fazenda, { eager: true })
  @JoinColumn({ name: 'fazenda_id', referencedColumnName: 'id' })
  fazenda: Fazenda;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  data_venda: Date;

  @Column({ type: 'int', nullable: true })
  quantidade_vendida: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  valor_venda: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  peso_venda: number;

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