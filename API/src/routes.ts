import { Router } from "express";
import cors from 'cors';
import { FazendaController } from "./controllers/fazendaController";
import { UsuarioController } from "./controllers/usuarioController";
import { UsuarioFazendaController } from "./controllers/usuarioFazendaController";
import { GranjaController } from "./controllers/granjaController";
import { TipoGranjaController } from "./controllers/tipoGranjaController";
import { BaiaController } from "./controllers/baiaController";
import { AnimalController } from "./controllers/animalController";
import { OcupacaoController } from "./controllers/ocupacaoController";
import { AnotacaoController } from "./controllers/anotacaoController";
import { LoteController } from "./controllers/loteController";
import { verifyToken } from "./middleware/verifyToken";
import { AuthController } from "./controllers/authController";
import { CidadeController } from "./controllers/cidadeController";
import { MovimentacaoController } from "./controllers/movimentacaoController";
import { InseminacaoController } from "./controllers/inseminacaoController";
import { DashboardController } from "./controllers/dashboardController";
const routes = Router();

const corsOptions = {
    origin: ['http://localhost:3000', 'http://localhost:3001', 'http://localhost:3002'], // Agora aceita ambos
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true, // Permite cookies/credenciais
};

routes.use(cors(corsOptions));

// Usuario Routes - Sem necessidade de autenticação
//usuario rotas
const usuarioController = new UsuarioController();
routes.post('/usuarios', usuarioController.create);

// Auth Routes - Sem necessidade de autenticação
//auth rotas
const authController = new AuthController();
routes.post('/auth', authController.auth);
routes.post('/auth/refresh', authController.refreshToken);
routes.post('/auth/logout', authController.logout);

// Middleware global para todas as rotas, exceto a de login
routes.use(verifyToken);

//fazenda rotas
const fazendaController = new FazendaController();
routes.post('/fazendas', fazendaController.createOrUpdate);

//usuarioFazenda rotas
const usuarioFazendaController = new UsuarioFazendaController();
routes.get('/usuariofazendas/:usuario_id', usuarioFazendaController.listFazendas);

//TipoGranja
const tipoGranjaController = new TipoGranjaController();
routes.get('/tipogranjas', tipoGranjaController.listAll);

//Granja
const granjaController = new GranjaController();
routes.post('/granjas', granjaController.createOrUpdate);
routes.put('/granjas/:granja_id', granjaController.createOrUpdate); 
routes.delete('/granjas/:granja_id', granjaController.delete); 
routes.get('/granjas/:fazenda_id', granjaController.list);
routes.get('/granjas/granja/:granja_id', granjaController.getById);

//Baia
const baiaController = new BaiaController();
routes.post('/baias', baiaController.createOrUpdate);
routes.put('/baias/:baia_id', baiaController.createOrUpdate); 
routes.delete('/baias/:baia_id',baiaController.delete); 
routes.get('/baias/:granja_id', baiaController.listByGranja);
routes.get('/baias/byFazenda/:fazenda_id', baiaController.listByFazenda);
routes.get('/baias/baia/:baia_id', baiaController.getById);
routes.get('/baias/byFazendaAndTipo/:fazenda_id/:tipoGranja_id', baiaController.listByFazendaAndTipo);

//Cidade
const cidadeController = new CidadeController();
routes.get('/cidades', cidadeController.list);

//Animal
const animalController = new AnimalController();
routes.post('/animais', animalController.createOrUpdate);
routes.put('/animais/:animal_id', animalController.createOrUpdate);
routes.delete('/animais/:animal_id', animalController.delete); 
routes.get('/animais/:fazenda_id', animalController.list);
routes.get('/animais/disponiveislote/:fazenda_id', animalController.listDisponivelParaLote);
routes.get('/animais/porcos/:fazenda_id', animalController.listPorcos);
routes.get('/animais/liveanddie/:fazenda_id', animalController.listLiveAndDie);
routes.get('/animais/animal/:animal_id', animalController.getById);
routes.get('/animais/nascimentos/:ocupacao_id', animalController.listNascimentos);
routes.post('/animais/adicionar-nascimento', animalController.createNascimento);
routes.delete('/animais/nascimentos/:animal_id', animalController.deleteNascimento);
routes.put('/animais/nascimentos/:animal_id', animalController.editarStatusNascimento); 

//Anotacao
const anotacaoController = new AnotacaoController();
routes.post('/anotacoes', anotacaoController.createOrUpdate);
routes.put('/anotacoes/:anotacao_id', anotacaoController.createOrUpdate); 
routes.delete('/anotacoes/:anotacao_id', anotacaoController.delete); 
routes.get('/anotacoes/:fazenda_id', anotacaoController.list);
routes.get('/anotacoes/getbybaia/:baia_id', anotacaoController.listByBaia);
routes.get('/anotacoes/anotacao/:anotacao_id', anotacaoController.getById);

//Lote
const loteController = new LoteController();
routes.post('/lotes', loteController.createOrUpdate);
routes.get('/lotes/:fazenda_id', loteController.list);
routes.get('/lotes/ativos/:fazenda_id', loteController.listAtivo);
routes.delete('/lotes/:lote_id', loteController.delete);
routes.put('/lotes/:lote_id', loteController.createOrUpdate);
routes.get('/lotes/lote/:lote_id', loteController.getById); 

//Ocupacao
const ocupacaoController = new OcupacaoController();
routes.post('/ocupacoes', ocupacaoController.createOrUpdate);
routes.get('/ocupacoes/ocupacao/:ocupacao_id', ocupacaoController.getById);
routes.get('/ocupacoes/getbybaia/:baia_id', ocupacaoController.getByBaiaId);
routes.get('/ocupacoes/:fazenda_id', ocupacaoController.list);
routes.post('/ocupacoes/movimentar-animais', ocupacaoController.movimentarAnimais);

//Movimentacao
const movimentacaoController = new MovimentacaoController();
routes.get('/movimentacoes/:fazenda_id', movimentacaoController.listByFazenda);

//Inseminacao
const inseminacaoController = new InseminacaoController();
routes.post('/inseminacao', inseminacaoController.inseminarAnimais);
routes.get('/inseminacao/:fazenda_id', inseminacaoController.listByFazenda);

//Dashboard
const dashboardController = new DashboardController();
routes.get('/dashboard/:fazenda_id', dashboardController.list);

export default routes