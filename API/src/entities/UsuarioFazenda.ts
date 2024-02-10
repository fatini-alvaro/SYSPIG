import { Column, Entity, JoinColumn, JoinTable, ManyToMany, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { TipoUsuario } from "./TipoUsuario";
import { Usuario } from "./Usuario";
import { Fazenda } from "./Fazenda";


@Entity('usuario_fazenda')
export class UsuarioFazenda {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => TipoUsuario, tipousuario => tipousuario.usuarios)
  @JoinColumn({name: 'tipo_usuario_id', referencedColumnName: 'id'})
  tipoUsuario: TipoUsuario;

  @ManyToOne(() => Usuario, { eager: true }) // Muitos UsuarioFazenda podem pertencer a um Usuario
  @JoinColumn({ name: 'usuario_id' }) // Nome da coluna que armazenará o id do usuário
  usuario: Usuario;

  @ManyToOne(() => Fazenda, { eager: true }) // Muitos UsuarioFazenda podem pertencer a uma Fazenda
  @JoinColumn({ name: 'fazenda_id' }) // Nome da coluna que armazenará o id da fazenda
  fazenda: Fazenda;

}