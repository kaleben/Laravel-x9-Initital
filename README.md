# Guia de instalação

## Pré-requisitos

É necessário ter instalado em sua máquina local os seguintes programas
- Docker
- Git

## Clonando o projeto

Clone o repositorio em uma pasta local

```cmd
$ git clone https://github.com/kaleben/laravel9-initital.git nomeProjeto
```

Vá para dentro da pasta do projeto

```cmd
$ cd nomeProjeto
```

E edite o docker-compose.yml caso necessário.

## Iniciando o container

Agora rode o comando

```cmd
$ docker-compose up -d
```

Com isso o docker irá montar e subir as imagens. Por padrão o docker-compose vêm com app_laravel contendo o projeto em si e web_laravel apontando para o NGNIX.

## Acessando container e finalizando instalação

A partir desse ponto, você já é capaz de acessar seu localhost na porta definida no docker-compose (o padrão é 8008), com isse será retornado um erro na tela. Não se preocupe, esse comportamento já é esperado.

Agora você precisa entrar dentro do seu container do app_laravel

```cmd
$ docker exec -it app_laravel /bin/bash
```

No seu terminal irá aparecer algo como

```cmd
$ root@e73a431ceba8:/var/www#
```

Isso significa que você já está dentro do container do deu projeto, rodando o comando

```cmd
$ ls
```

Será possível ver todos os arquivos do Laravel.

### Instalando packages

Agora dentro do container, é necessário instalar os pacotes contidos no package.json. Para isso rode o comando

```cmd
$ composer install
```

Isso irá instalar todos os pacotes necessários.

### Comandos NPM

Agora para o funcionamento do bootstrap e fontawesome rode o comando

```cmd
$ npm install
```

Em seguida 

```cmd
$ npm run @development
```
Com isso seu projeto está 99% configurado!

### Criando o arquivo .env

Para finalizar rode o comando

```cmd
$ cp .env.example ./.env
```

Isso criará o arquivo .env com base no .env.example. Então rode o comando

```cmd
$ php artisan key:generate
```

e

```cmd
$ exit
```

Para sair do container

### Pronto!

Tudo pronto! agora acessando novamente o localhost em seu navegador já será possível ver a página Welcome padrão do Laravel.
