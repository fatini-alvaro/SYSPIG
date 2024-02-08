import express from 'express';
import { AppDataSource } from './data-source';
const bcrypt = require('bcrypt');

AppDataSource.initialize().then(() => {
  const app = express();

  app.use(express.json());

  const usuarios: { nome: string; senha: string }[] = [];

  app.get('/usuarios', (req, res) => {
    res.json(usuarios);
  });

  app.post('/usuarios', async (req, res) => {
    try {
      const hashedPassword = await bcrypt.hash(req.body.senha, 10);
      const usuario = { nome: req.body.nome, senha: hashedPassword };
      usuarios.push(usuario);
      res.status(201).send();
    } catch (e) {
      res.status(500).send();
    }
  });

  app.get('/', (req, res) => {
    return res.json('tudo certo')
  })

  return app.listen(process.env.PORT);
})