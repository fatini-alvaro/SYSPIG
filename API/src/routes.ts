import { Router } from "express";
import { FazendaController } from "./controllers/fazendaController";
import { UsuarioController } from "./controllers/usuarioController";
import { TipoUsuarioController } from "./controllers/tipoUsuarioController";
import { UsuarioFazendaController } from "./controllers/usuarioFazendaController";
import { GranjaController } from "./controllers/granjaController";
import { TipoGranjaController } from "./controllers/tipoGranjaController";
const routes = Router();

//fazenda rotas
routes.post('/fazendas', new FazendaController().create);

//usuario rotas
routes.post('/usuarios', new UsuarioController().create);

//tipoUsuarios rotas
routes.post('/tipousuarios', new TipoUsuarioController().create);

//usuarioFazenda rotas
routes.post('/usuariofazendas', new UsuarioFazendaController().create);
routes.get('/usuariofazendas/:usuario_id', new UsuarioFazendaController().list);

//TipoGranja
routes.get('/tipogranjas', new TipoGranjaController().listAll);
routes.post('/tipogranjas', new TipoGranjaController().create);

//Granja
routes.post('/granjas', new GranjaController().create);
routes.get('/granjas/:fazenda_id', new GranjaController().list);

export default routes