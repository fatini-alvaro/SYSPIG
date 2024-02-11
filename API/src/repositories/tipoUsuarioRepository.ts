import { AppDataSource } from "../data-source";
import { TipoUsuario } from "../entities/TipoUsuario";


export const tipoUsuarioRepository = AppDataSource.getRepository(TipoUsuario);