import 'dotenv/config'
import 'reflect-metadata'
import { DataSource } from "typeorm";
import path from 'path';

const port = process.env.DB_PORT as number | undefined;

// Configuração para produção (arquivos compilados JS)
const productionConfig = {
  entities: [path.join(__dirname, 'entities', '*.js')],
  migrations: [path.join(__dirname, 'migrations', '*.js')]
};

// Configuração para desenvolvimento (arquivos TS)
const developmentConfig = {
  entities: [path.join(__dirname, 'src', 'entities', '*.ts')],
  migrations: [path.join(__dirname, 'src', 'migrations', '*.ts')]
};

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST,
  port: port,
  username: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  ...(process.env.NODE_ENV === 'production' ? productionConfig : developmentConfig),
  synchronize: false, // Importante: deixar false em produção
  logging: true // Ajuda no debug
});