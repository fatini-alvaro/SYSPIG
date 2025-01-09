import { Router } from "express";
import { FazendaController } from "./controllers/fazendaController";
import { UsuarioController } from "./controllers/usuarioController";
import { TipoUsuarioController } from "./controllers/tipoUsuarioController";
import { UsuarioFazendaController } from "./controllers/usuarioFazendaController";
import { GranjaController } from "./controllers/granjaController";
import { TipoGranjaController } from "./controllers/tipoGranjaController";
import { cidadeController } from "./controllers/cidadeController";
import { BaiaController } from "./controllers/baiaController";
import { AnimalController } from "./controllers/animalController";
import { OcupacaoController } from "./controllers/ocupacaoController";
import { AnotacaoController } from "./controllers/anotacaoController";
import { LoteController } from "./controllers/loteController";
const routes = Router();

//fazenda rotas
routes.post('/fazendas', new FazendaController().create);

//usuario rotas
routes.post('/usuarios', new UsuarioController().create);
routes.post('/auth', new UsuarioController().auth);

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
routes.put('/granjas/:granja_id', new GranjaController().update); 
routes.delete('/granjas/:granja_id', new GranjaController().delete); 
routes.get('/granjas/:fazenda_id', new GranjaController().list);

//Baia
routes.post('/baias', new BaiaController().create);
routes.put('/baias/:baia_id', new BaiaController().update); 
routes.delete('/baias/:baia_id', new BaiaController().delete); 
routes.get('/baias/:granja_id', new BaiaController().list);
routes.get('/baias/byFazenda/:fazenda_id', new BaiaController().listByFazenda);
routes.get('/baias/baia/:baia_id', new BaiaController().getById);

//Cidade
routes.get('/cidades', new cidadeController().list);

//Animal
routes.post('/animais', new AnimalController().create);
routes.put('/animais/:animal_id', new AnimalController().update); 
routes.delete('/animais/:animal_id', new AnimalController().delete); 
routes.get('/animais/:fazenda_id', new AnimalController().list);
routes.get('/animais/animal/:animal_id', new AnimalController().getById);

//Anotacao
routes.post('/anotacoes', new AnotacaoController().create);
routes.put('/anotacoes/:anotacao_id', new AnotacaoController().update); 
routes.delete('/anotacoes/:anotacao_id', new AnotacaoController().delete); 
routes.get('/anotacoes/:fazenda_id', new AnotacaoController().list);
routes.get('/anotacoes/getbybaia:baia_id', new AnotacaoController().listByBaia);

//Lote
routes.post('/lotes', new LoteController().create);
routes.get('/lotes/:fazenda_id', new LoteController().list);
routes.delete('/lotes/:lote_id', new LoteController().delete);
routes.put('/lotes/:lote_id', new LoteController().update); 

//Ocupacao
routes.post('/ocupacoes', new OcupacaoController().create);
routes.get('/ocupacoes/ocupacao/:ocupacao_id', new OcupacaoController().getById);

export default routes