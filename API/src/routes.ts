import { Router } from "express";
import cors from 'cors';
import { AsyncHandler } from "./@types/express";
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

// Função wrapper para tratamento de erros
const asyncHandler = (handler: AsyncHandler): AsyncHandler => {
    return async (req, res, next) => {
        try {
            await handler(req, res, next);
        } catch (error) {
            next(error);
        }
    };
};

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
routes.post('/usuarios', asyncHandler(usuarioController.create.bind(usuarioController)));
routes.post('/auth', asyncHandler(authController.auth.bind(authController)));
routes.post('/auth/refresh', asyncHandler(authController.refreshToken.bind(authController)));
routes.post('/auth/logout', asyncHandler(authController.logout.bind(authController)));

// Middleware de autenticação global
routes.use(verifyToken);

// Rotas protegidas (com autenticação)

// Rotas de Usuário
routes.put('/usuarios/:id', asyncHandler(usuarioController.update.bind(usuarioController)));
routes.get('/usuarios/:fazenda_id', asyncHandler(usuarioController.listByFazenda.bind(usuarioController)));
routes.get('/usuarios/perfil/:id', asyncHandler(usuarioController.getPerfilUsuario.bind(usuarioController)));
routes.post('/usuarios/:id/change-password', asyncHandler(usuarioController.changeUsuarioPassword.bind(usuarioController)));

// Rotas de Fazenda
routes.post('/fazendas', asyncHandler(fazendaController.createOrUpdate.bind(fazendaController)));
routes.get('/fazendas/:usuario_id', asyncHandler(fazendaController.listFazendasDisponiveis.bind(fazendaController)));

// Rotas de Usuário-Fazenda
routes.get('/usuariofazendas/:usuario_id', asyncHandler(usuarioFazendaController.listFazendas.bind(usuarioFazendaController)));
routes.delete("/usuariofazendas/:id", asyncHandler(usuarioFazendaController.deleteUsuarioFazenda.bind(usuarioFazendaController)));
routes.post('/usuariofazendas', asyncHandler(usuarioFazendaController.create.bind(usuarioFazendaController)));

// Rotas de Tipo de Granja
routes.get('/tipogranjas', asyncHandler(tipoGranjaController.listAll.bind(tipoGranjaController)));

// Rotas de Granja
routes.post('/granjas', asyncHandler(granjaController.createOrUpdate.bind(granjaController)));
routes.put('/granjas/:granja_id', asyncHandler(granjaController.createOrUpdate.bind(granjaController))); 
routes.delete('/granjas/:granja_id', asyncHandler(granjaController.delete.bind(granjaController))); 
routes.get('/granjas/:fazenda_id', asyncHandler(granjaController.list.bind(granjaController)));
routes.get('/granjas/granja/:granja_id', asyncHandler(granjaController.getById.bind(granjaController)));

// Rotas de Baia
routes.post('/baias', asyncHandler(baiaController.createOrUpdate.bind(baiaController)));
routes.put('/baias/:baia_id', asyncHandler(baiaController.createOrUpdate.bind(baiaController))); 
routes.delete('/baias/:baia_id', asyncHandler(baiaController.delete.bind(baiaController))); 
routes.get('/baias/:granja_id', asyncHandler(baiaController.listByGranja.bind(baiaController)));
routes.get('/baias/byFazenda/:fazenda_id', asyncHandler(baiaController.listByFazenda.bind(baiaController)));
routes.get('/baias/baia/:baia_id', asyncHandler(baiaController.getById.bind(baiaController)));
routes.get('/baias/byFazendaAndTipo/:fazenda_id/:tipoGranja_id', asyncHandler(baiaController.listByFazendaAndTipo.bind(baiaController)));
routes.get('/baias/crechescomleitoes/:fazenda_id', asyncHandler(baiaController.listBaiasComLeitoesParaVenda.bind(baiaController)));

// Rotas de Cidade
routes.get('/cidades', asyncHandler(cidadeController.list.bind(cidadeController)));

// Rotas de Animal
routes.post('/animais', asyncHandler(animalController.createOrUpdate.bind(animalController)));
routes.put('/animais/:animal_id', asyncHandler(animalController.createOrUpdate.bind(animalController)));
routes.delete('/animais/:animal_id', asyncHandler(animalController.delete.bind(animalController))); 
routes.get('/animais/:fazenda_id', asyncHandler(animalController.list.bind(animalController)));
routes.get('/animais/disponiveislote/:fazenda_id', asyncHandler(animalController.listDisponivelParaLote.bind(animalController)));
routes.get('/animais/porcos/:fazenda_id', asyncHandler(animalController.listPorcos.bind(animalController)));
routes.get('/animais/liveanddie/:fazenda_id', asyncHandler(animalController.listLiveAndDie.bind(animalController)));
routes.get('/animais/animal/:animal_id', asyncHandler(animalController.getById.bind(animalController)));
routes.get('/animais/nascimentos/:ocupacao_id', asyncHandler(animalController.listNascimentos.bind(animalController)));
routes.post('/animais/adicionar-nascimento', asyncHandler(animalController.createNascimento.bind(animalController)));
routes.delete('/animais/nascimentos/:animal_id', asyncHandler(animalController.deleteNascimento.bind(animalController)));
routes.put('/animais/nascimentos/:animal_id', asyncHandler(animalController.editarStatusNascimento.bind(animalController))); 

// Rotas de Anotação
routes.post('/anotacoes', asyncHandler(anotacaoController.createOrUpdate.bind(anotacaoController)));
routes.put('/anotacoes/:anotacao_id', asyncHandler(anotacaoController.createOrUpdate.bind(anotacaoController))); 
routes.delete('/anotacoes/:anotacao_id', asyncHandler(anotacaoController.delete.bind(anotacaoController))); 
routes.get('/anotacoes/:fazenda_id', asyncHandler(anotacaoController.list.bind(anotacaoController)));
routes.get('/anotacoes/getbybaia/:baia_id', asyncHandler(anotacaoController.listByBaia.bind(anotacaoController)));
routes.get('/anotacoes/anotacao/:anotacao_id', asyncHandler(anotacaoController.getById.bind(anotacaoController)));

// Rotas de Lote
routes.post('/lotes', asyncHandler(loteController.createOrUpdate.bind(loteController)));
routes.get('/lotes/:fazenda_id', asyncHandler(loteController.list.bind(loteController)));
routes.get('/lotes/ativos/:fazenda_id', asyncHandler(loteController.listAtivo.bind(loteController)));
routes.delete('/lotes/:lote_id', asyncHandler(loteController.delete.bind(loteController)));
routes.put('/lotes/:lote_id', asyncHandler(loteController.createOrUpdate.bind(loteController)));
routes.get('/lotes/lote/:lote_id', asyncHandler(loteController.getById.bind(loteController))); 

// Rotas de Ocupação
routes.post('/ocupacoes', asyncHandler(ocupacaoController.createOrUpdate.bind(ocupacaoController)));
routes.get('/ocupacoes/ocupacao/:ocupacao_id', asyncHandler(ocupacaoController.getById.bind(ocupacaoController)));
routes.get('/ocupacoes/getbybaia/:baia_id', asyncHandler(ocupacaoController.getByBaiaId.bind(ocupacaoController)));
routes.get('/ocupacoes/:fazenda_id', asyncHandler(ocupacaoController.list.bind(ocupacaoController)));
routes.post('/ocupacoes/movimentar-animais', asyncHandler(ocupacaoController.movimentarAnimais.bind(ocupacaoController)));

// Rotas de Movimentação
routes.get('/movimentacoes/:fazenda_id', asyncHandler(movimentacaoController.listByFazenda.bind(movimentacaoController)));

// Rotas de Inseminação
routes.post('/inseminacao', asyncHandler(inseminacaoController.inseminarAnimais.bind(inseminacaoController)));
routes.get('/inseminacao/:fazenda_id', asyncHandler(inseminacaoController.listByFazenda.bind(inseminacaoController)));

// Rotas de Dashboard
routes.get('/dashboard/:fazenda_id', asyncHandler(dashboardController.list.bind(dashboardController)));

// Rotas de Venda
routes.get('/vendas/:fazenda_id', asyncHandler(vendaController.list.bind(vendaController)));
routes.post('/vendas', asyncHandler(vendaController.createVenda.bind(vendaController)));

export default routes;