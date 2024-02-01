import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Usuario } from "./Usuario";


@Entity('tipo_usuario')
export class TipoUsuario {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'text' })
  descricao: string;

  @OneToMany(() => Usuario, usuario => usuario.tipoUsuario)
  usuarios: Usuario[];

}