import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { UsuarioFazenda } from "./UsuarioFazenda";
import { Usuario } from "./Usuario";
import { Cidade } from "./Cidade";


@Entity('fazenda')
export class Fazenda {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'text' })
  nome: string;

  @OneToMany(() => UsuarioFazenda, usuarioFazenda => usuarioFazenda.fazenda)
  usuarioFazendas: UsuarioFazenda[];

  @ManyToOne(() => Usuario, usuario => usuario.fazendas)
  @JoinColumn({name: 'usuario_id', referencedColumnName: 'id'})
  usuario: Usuario;

  @ManyToOne(() => Cidade, { eager: true }) // Muitas fazendas podem pertencer a uma cidade
  @JoinColumn({ name: 'cidade_id', referencedColumnName: 'id' }) 
  cidade: Cidade;

}