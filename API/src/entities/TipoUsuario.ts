import { Column, Entity, OneToMany, PrimaryColumn } from "typeorm";
import { Usuario } from "./Usuario";
import { TipoUsuarioId } from "../constants/tipoUsuarioConstants";

@Entity('tipo_usuario')
export class TipoUsuario {
  @PrimaryColumn({ type: 'int' })
  id: TipoUsuarioId;

  @Column({ type: 'text' })
  descricao: string;

  @OneToMany(() => Usuario, usuario => usuario.tipoUsuario)
  usuarios: Usuario[];
}
