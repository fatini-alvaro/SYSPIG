import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { TipoUsuario } from "./TipoUsuario";
import { Fazenda } from "./Fazenda";
import { UsuarioFazenda } from "./UsuarioFazenda";


@Entity('usuario')
export class Usuario {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'text' })
  nome: string;

  @Column({ type: 'text' })
  email: string;

  @ManyToOne(() => TipoUsuario, tipousuario => tipousuario.usuarios)
  @JoinColumn({name: 'tipo_usuario_id', referencedColumnName: 'id'})
  tipoUsuario: TipoUsuario;

  @Column()
  senha: string; 

  @OneToMany(() => UsuarioFazenda, usuarioFazenda => usuarioFazenda.usuario)
  usuarioFazendas: UsuarioFazenda[];
  
  @OneToMany(() => Fazenda, fazenda => fazenda.usuario)
  fazendas: Fazenda[];
  
}