import { AppDataSource } from "../data-source";
import { Usuario } from "../entities/Usuario";

export const usuarioRepository = AppDataSource.getRepository(Usuario);