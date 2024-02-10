import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { UsuarioFazenda } from "./UsuarioFazenda";
import { Usuario } from "./Usuario";


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

}