import { Router } from "express";
import { FazendaController } from "./controllers/fazendaController";
import { UsuarioController } from "./controllers/usuarioController";
import { TipoUsuarioController } from "./controllers/tipoUsuarioController";
import { UsuarioFazendaController } from "./controllers/usuarioFazendaController";

const routes = Router();

//fazenda rotas
routes.post('/fazendas', new FazendaController().create);

//usuario rotas
routes.post('/usuarios', new UsuarioController().create);

//tipoUsuarios rotas
routes.post('/tipousuarios', new TipoUsuarioController().create);

//usuarioFazenda rotas
routes.post('/usuariofazendas', new UsuarioFazendaController().create);

export default routes