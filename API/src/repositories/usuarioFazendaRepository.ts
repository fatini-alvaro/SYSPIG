import { AppDataSource } from "../data-source";
import { UsuarioFazenda } from "../entities/UsuarioFazenda";

export const usuarioFazendaRepository = AppDataSource.getRepository(UsuarioFazenda);