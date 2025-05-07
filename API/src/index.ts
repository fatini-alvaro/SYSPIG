import express from 'express';
import { AppDataSource } from './data-source';
import routes from './routes';

AppDataSource.initialize().then(() => {
  const app = express();

  app.use(express.json());
  app.use(routes);

  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
  });
});
