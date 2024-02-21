import express from 'express';
import { AppDataSource } from './data-source';
import routes from './routes';
// const bcrypt = require('bcrypt');

AppDataSource.initialize().then(() => {
  const app = express();

  app.use(express.json());

  app.use(routes);

  return app.listen(process.env.PORT);

  // const usuarios: { nome: string; senha: string }[] = [];

  // app.get('/usuarios', (req, res) => {
  //   res.json(usuarios);
  // });

  // app.post('/usuarios', async (req, res) => {
  //   try {
  //     const hashedSenha = await bcrypt.hash(req.body.senha, 10);
  //     const usuario = { nome: req.body.nome, senha: hashedSenha };
  //     usuarios.push(usuario);
  //     res.status(201).send();
  //   } catch (e) {
  //     res.status(500).send();
  //   }
  // });

  // app.get('/', (req, res) => {
  //   return res.json('tudo certo')
  // })

  // app.post('/usuarios/login', async (req, res) => {
  //   const usuario = usuarios.find(usuario => usuario.nome === req.body.nome);
  //   if(!usuario)
  //     return res.status(400).send('Não foi possível encontrar o usuário');

  //   try {
  //     if(await bcrypt.compare(req.body.senha, usuario.senha)){
  //       res.send('Você logou com sucesso')
  //     } else {
  //       res.status(401).send('Senha incorreta')
  //     }
  //   } catch (e) {
  //     res.status(500).send();   
  //   }
    
  // });
  
})