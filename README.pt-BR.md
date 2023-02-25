Datasource Toolkit
==================

Este projeto é um conjunto de ferramentas que auxiliam a criar esquemas de
bancos de dados e migrações

Basicamente, é um conjunto de _scripts_ que configura a conexão com o banco de
dados, aplica e/ou reverte a migração de dados através de versões e _patches_
utilizando arquivos SQL com marcações que indicarão o que deve ser aplicado ou
removido.

## Instalação

Considerando o diretório de instalação local para aplicações (`/usr/local`),
basta executar o comando:

```sh
$ make install
```

Para instalação em outro diretório:

```sh
$ make install prefix=/meu/diretorio
```

## Bancos de dados suportados

- PostgreSQL
- MySQL/MariaDB

## Fluxo de trabalho comum

**Inicialização**
: Configurações básicas para ajustes dos _datasources_.

**Configuração**
: Configuração de um ou mais _datasources_ e respectivos repositórios.

**Migração**
: Após configuração, controle de migração de dados.
