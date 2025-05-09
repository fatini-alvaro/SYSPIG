import { Router } from "express";
import cors from 'cors';
import { verifyToken } from "./middleware/verifyToken";

// Importação dos controllers
import { AuthController } from "./controllers/authController";
import { UsuarioController } from "./controllers/usuarioController";
import { FazendaController } from "./controllers/fazendaController";
import { UsuarioFazendaController } from "./controllers/usuarioFazendaController";
import { TipoGranjaController } from "./controllers/tipoGranjaController";
import { GranjaController } from "./controllers/granjaController";
import { BaiaController } from "./controllers/baiaController";
import { CidadeController } from "./controllers/cidadeController";
import { AnimalController } from "./controllers/animalController";
import { AnotacaoController } from "./controllers/anotacaoController";
import { LoteController } from "./controllers/loteController";
import { OcupacaoController } from "./controllers/ocupacaoController";
import { MovimentacaoController } from "./controllers/movimentacaoController";
import { InseminacaoController } from "./controllers/inseminacaoController";
import { DashboardController } from "./controllers/dashboardController";
import { VendaController } from "./controllers/vendaController";

const routes = Router();

// Configuração do CORS
const devOrigins = [
    'http://localhost:3000',
    'http://localhost:3001',
    'http://localhost:3002',
];

const prodOrigins = [
    'https://syspig-web.onrender.com',
];

const corsOptions = {
    origin: process.env.NODE_ENV === 'production' ? prodOrigins : devOrigins,
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
};

routes.use(cors(corsOptions));

// Inicialização dos controllers
const authController = new AuthController();
const usuarioController = new UsuarioController();
const fazendaController = new FazendaController();
const usuarioFazendaController = new UsuarioFazendaController();
const tipoGranjaController = new TipoGranjaController();
const granjaController = new GranjaController();
const baiaController = new BaiaController();
const cidadeController = new CidadeController();
const animalController = new AnimalController();
const anotacaoController = new AnotacaoController();
const loteController = new LoteController();
const ocupacaoController = new OcupacaoController();
const movimentacaoController = new MovimentacaoController();
const inseminacaoController = new InseminacaoController();
const dashboardController = new DashboardController();
const vendaController = new VendaController();

// Rotas públicas (sem autenticação)
routes.post('/usuarios', (req, res) => usuarioController.create(req, res));
routes.post('/auth', (req, res) => authController.auth(req, res));
routes.post('/auth/refresh', (req, res) => authController.refreshToken(req, res));
routes.post('/auth/logout', (req, res) => authController.logout(req, res));

// Middleware de autenticação global
routes.use(verifyToken);

// Rotas protegidas (com autenticação)

// Rotas de Usuário
routes.put('/usuarios/:id', (req, res) => usuarioController.update(req, res));
routes.get('/usuarios/:fazenda_id', (req, res) => usuarioController.listByFazenda(req, res));
routes.get('/usuarios/perfil/:id', (req, res) => usuarioController.getPerfilUsuario(req, res));
routes.post('/usuarios/:id/change-password', (req, res) => usuarioController.changeUsuarioPassword(req, res));

// Rotas de Fazenda
routes.post('/fazendas', (req, res) => fazendaController.createOrUpdate(req, res));
routes.get('/fazendas/:usuario_id', (req, res) => fazendaController.listFazendasDisponiveis(req, res));

// Rotas de Usuário-Fazenda
routes.get('/usuariofazendas/:usuario_id', (req, res) => usuarioFazendaController.listFazendas(req, res));
routes.delete("/usuariofazendas/:id", (req, res) => usuarioFazendaController.deleteUsuarioFazenda(req, res));
routes.post('/usuariofazendas', (req, res) => usuarioFazendaController.create(req, res));

// Rotas de Tipo de Granja
routes.get('/tipogranjas', (req, res) => tipoGranjaController.listAll(req, res));

// Rotas de Granja
routes.post('/granjas', (req, res) => granjaController.createOrUpdate(req, res));
routes.put('/granjas/:granja_id', (req, res) => granjaController.createOrUpdate(req, res)); 
routes.delete('/granjas/:granja_id', (req, res) => granjaController.delete(req, res)); 
routes.get('/granjas/:fazenda_id', (req, res) => granjaController.list(req, res));
routes.get('/granjas/granja/:granja_id', (req, res) => granjaController.getById(req, res));

// Rotas de Baia
routes.post('/baias', (req, res) => baiaController.createOrUpdate(req, res));
routes.put('/baias/:baia_id', (req, res) => baiaController.createOrUpdate(req, res)); 
routes.delete('/baias/:baia_id', (req, res) => baiaController.delete(req, res)); 
routes.get('/baias/:granja_id', (req, res) => baiaController.listByGranja(req, res));
routes.get('/baias/byFazenda/:fazenda_id', (req, res) => baiaController.listByFazenda(req, res));
routes.get('/baias/baia/:baia_id', (req, res) => baiaController.getById(req, res));
routes.get('/baias/byFazendaAndTipo/:fazenda_id/:tipoGranja_id', (req, res) => baiaController.listByFazendaAndTipo(req, res));
routes.get('/baias/crechescomleitoes/:fazenda_id', (req, res) => baiaController.listBaiasComLeitoesParaVenda(req, res));

// Rotas de Cidade
routes.get('/cidades', (req, res) => cidadeController.list(req, res));

// Rotas de Animal
routes.post('/animais', (req, res) => animalController.createOrUpdate(req, res));
routes.put('/animais/:animal_id', (req, res) => animalController.createOrUpdate(req, res));
routes.delete('/animais/:animal_id', (req, res) => animalController.delete(req, res)); 
routes.get('/animais/:fazenda_id', (req, res) => animalController.list(req, res));
routes.get('/animais/disponiveislote/:fazenda_id', (req, res) => animalController.listDisponivelParaLote(req, res));
routes.get('/animais/porcos/:fazenda_id', (req, res) => animalController.listPorcos(req, res));
routes.get('/animais/liveanddie/:fazenda_id', (req, res) => animalController.listLiveAndDie(req, res));
routes.get('/animais/animal/:animal_id', (req, res) => animalController.getById(req, res));
routes.get('/animais/nascimentos/:ocupacao_id', (req, res) => animalController.listNascimentos(req, res));
routes.post('/animais/adicionar-nascimento', (req, res) => animalController.createNascimento(req, res));
routes.delete('/animais/nascimentos/:animal_id', (req, res) => animalController.deleteNascimento(req, res));
routes.put('/animais/nascimentos/:animal_id', (req, res) => animalController.editarStatusNascimento(req, res)); 

// Rotas de Anotação
routes.post('/anotacoes', (req, res) => anotacaoController.createOrUpdate(req, res));
routes.put('/anotacoes/:anotacao_id', (req, res) => anotacaoController.createOrUpdate(req, res)); 
routes.delete('/anotacoes/:anotacao_id', (req, res) => anotacaoController.delete(req, res)); 
routes.get('/anotacoes/:fazenda_id', (req, res) => anotacaoController.list(req, res));
routes.get('/anotacoes/getbybaia/:baia_id', (req, res) => anotacaoController.listByBaia(req, res));
routes.get('/anotacoes/anotacao/:anotacao_id', (req, res) => anotacaoController.getById(req, res));

// Rotas de Lote
routes.post('/lotes', (req, res) => loteController.createOrUpdate(req, res));
routes.get('/lotes/:fazenda_id', (req, res) => loteController.list(req, res));
routes.get('/lotes/ativos/:fazenda_id', (req, res) => loteController.listAtivo(req, res));
routes.delete('/lotes/:lote_id', (req, res) => loteController.delete(req, res));
routes.put('/lotes/:lote_id', (req, res) => loteController.createOrUpdate(req, res));
routes.get('/lotes/lote/:lote_id', (req, res) => loteController.getById(req, res)); 

// Rotas de Ocupação
routes.post('/ocupacoes', (req, res) => ocupacaoController.createOrUpdate(req, res));
routes.get('/ocupacoes/ocupacao/:ocupacao_id', (req, res) => ocupacaoController.getById(req, res));
routes.get('/ocupacoes/getbybaia/:baia_id', (req, res) => ocupacaoController.getByBaiaId(req, res));
routes.get('/ocupacoes/:fazenda_id', (req, res) => ocupacaoController.list(req, res));
routes.post('/ocupacoes/movimentar-animais', (req, res) => ocupacaoController.movimentarAnimais(req, res));

// Rotas de Movimentação
routes.get('/movimentacoes/:fazenda_id', (req, res) => movimentacaoController.listByFazenda(req, res));

// Rotas de Inseminação
routes.post('/inseminacao', (req, res) => inseminacaoController.inseminarAnimais(req, res));
routes.get('/inseminacao/:fazenda_id', (req, res) => inseminacaoController.listByFazenda(req, res));

// Rotas de Dashboard
routes.get('/dashboard/:fazenda_id', (req, res) => dashboardController.list(req, res));

// Rotas de Venda
routes.get('/vendas/:fazenda_id', (req, res) => vendaController.list(req, res));
routes.post('/vendas', (req, res) => vendaController.createVenda(req, res));

export default routes;