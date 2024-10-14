# SYSPYG

Documentação para instalação e configuração do projeto API e Mobile.

## Tabela de Conteúdos

- [Overview](#overview)
- [Tecnologias](#tecnologias)
  - [API](#api)
  - [Mobile](#mobile)
  - [Banco de Dados](#banco-de-dados)
- [Setup](#setup)
  - [Instalações e configurações](#instalações-e-configurações)
    - [PostgreSQL 15](#postgresql-15)
    - [Node e Yarn](#node-e-yarn)
    - [Android Studio](#android-studio)
    - [Flutter](#flutter)
- [Rodando o Projeto](#rodando-o-projeto)
  - [Rodar API](#rodar-api)
  - [Rodar o Mobile](#rodar-o-mobile)

## Overview

Esse projeto é composto por:

- **API:** Fornece endpoints para gerenciar e processar dados, utilizando Node.js, TypeORM e Postgres.
- **Aplicação Mobile:** Aplicação cliente Flutter que consome a API para fornecer uma interface ao usuário.
- **Futuro:** Possível criação de um front-end web.

## Tecnologias

### API

- **Node.js**
- **TypeScript**
- **TypeORM**
- **Express**
- **PostgreSQL**
- **Yarn**
- **Bcrypt** (para autenticação)
- **dotenv** (para variáveis de ambiente)
- **Data Mapper Pattern**

### Mobile

- **Flutter**
- **Dart**
- **HTTP Package ou DIO** (para integração de API)
- **Provider** (gerenciamento de estado)
- **Shared Preferences**
- **Logger** (para logs)
- **flutter_datetime_picker**
- **Toast**

### Banco de Dados

- **PostgreSQL**
- Porta: `5432`
- Usuário: `alvaro`

## Setup

### Instalações e configurações
Comandos para máquinhas Linux.

#### PostgreSQL 15

1. **Adicionar repositório PostgreSQL:**
   - Abrir um terminal e rodar os seguintes comandos:
     ```bash
     sudo apt update
     sudo apt install wget ca-certificates
     ```

   - Adicionar o repositório do PostgreSQL:
     ```bash
     sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
     ```

   - Importe a chave de assinatura do repositório:
     ```bash
     wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
     ```

2. **Instalação:**
   - Atualize sua lista de pacotes:
     ```bash
     sudo apt update
     ```

   - Instale a versão 15 do PostgreSQL:
     ```bash
     sudo apt install postgresql-15
     ```

3. **Configurar:**
   - Alterar para o usuário PostgreSQL:
     ```bash
     sudo -i -u postgres
     ```

   - Acessar o prompt do PostgreSQL:
     ```bash
     psql
     ```

   - Definir a senha para o usuário postgres:
     ```bash
     ALTER USER postgres PASSWORD '1950';
     ```

### Node e Yarn

1. **Instalar Node.js:**

   Instalar Node.js com NVM:

   - Instalar o nvm (Node Version Manager) para gerenciar diferentes versões do Node.js:
     ```bash
     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
     ```

   - Após instalar o nvm, reinicie o terminal ou carregue o script:
     ```bash
     source ~/.bashrc
     ```
    
   - Verificar se o nvm foi instalado corretamente:
     ```bash
     nvm --version
     ```

   - Instalar a versão mais recente do Node.js:
     ```bash
     nvm install node
     ```

2. **Instalar Yarn:**
   - Após instalar o Node.js, instale o Yarn globalmente:
     ```bash
     npm install --global yarn
     ```
    
   - Verifique a instalação do Yarn:
     ```bash
     yarn -v
     ```

### Android Studio

### Flutter

## Rodando o Projeto

### Rodar API

1. **Instale as dependências da API:**
   - Após instalar o Node.js, instale o Yarn globalmente:
     ```bash
     yarn install
     ```

2. **Configure as variáveis de ambiente: Crie um arquivo .env na pasta api/ com as seguintes variáveis:**
     ```bash
     DB_HOST=
     DB_PORT=
     DB_USER=
     DB_PASS=
     DB_NAME=
     PORT=
     ```

3. **Rode as migrations:**
     ```bash
     yarn migration:run

### Rodar Mobile

1. **Instale as dependências do Flutter:**
     ```bash
     flutter pub get
     ```

2. **Para rodar o app mobile, use 'F5' (com debug) ou 'Ctrl + F5' (sem debug), ou por comando:**
     ```bash
     flutter run
     ```