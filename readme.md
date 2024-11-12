# Projeto com Docker Compose e NPM

Este projeto utiliza **Docker Compose** para facilitar a configuração do ambiente de desenvolvimento e **NPM** para rodar o servidor e popular o banco de dados com dados iniciais.

## Pré-requisitos

Antes de começar, você precisa ter as seguintes ferramentas instaladas:

- **Docker**: [Instalar Docker](https://docs.docker.com/get-docker/)
- **Node.js**: [Instalar Node.js](https://nodejs.org/)

## Passos para rodar o projeto

### 1. Clonar o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd <Pasta_do_Projeto>
```

### 2. Rodar o Docker Compose

O Docker Compose é utilizado para iniciar os containers do projeto (banco de dados, servidor, etc.). Para rodá-lo, execute o seguinte comando:

```
docker-compose up

```

### 3. Inicializar o banco de dados (se quiser)

Caso você precise inserir dados iniciais no banco de dados (como usuários ou registros), execute o seguinte comando:

```
bash
npm run seed
```

Este comando vai executar a seeds do banco de dados e adicionar os dados necessários para o funcionamento da aplicação.

### 4. Iniciar o servidor

Após os containers estarem rodando, o próximo passo é iniciar o servidor da aplicação. Para isso, execute o comando:

```
bash
npm run dev
```

## Grupo do TCC
- - **Joao Vitor Diamon**: [GITHUB](https://github.com/JoaoVitorDiamon)
- - **Eduarda Barbosa**: [GITHUB](https://github.com/dudaabarbosa)
- - **Gabriella Kaillany**: [GITHUB](https://github.com/Gabriella-Kailainy)
- - **Guilherme Araujo**: [GITHUB](https://github.com/GuilhermeAraujo539)
- - **Gabriel Fontes**: [GITHUB](https://github.com/gabrielfontesdesousa)
- - **Gabriel Falavena**: [GITHUB](https://github.com/gfalavena)
- - **Matheus Rodrigues**: [GITHUB](https://github.com/matheusrodriguesvxz)

### Ferramentas Utilizadas
-  **Flutter**
-  **Node.JS**
-  **Docker**
-  **Postgres**
-  **Drizzle ORM**
-  **ZOD**
-  **Fastfiy**