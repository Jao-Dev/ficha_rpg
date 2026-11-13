---
name: subir-postgres
description: Inicia o PostgreSQL (Docker) usado pelo projeto ficha_rpg — subir sempre que necessário, sem perguntar, e derrubar com docker compose down ao terminar. Use quando o banco estiver fora do ar (ex.: ActiveRecord::ConnectionNotEstablished / "connection refused" na porta 5432) ou quando o usuário pedir para subir ou derrubar o banco.
---

# Subir PostgreSQL do ficha_rpg

O banco do projeto roda em Docker Compose, fora da pasta do projeto, em `~/Docker/postgresql`.

## Regra de uso

- Sempre que o banco for necessário (specs, servidor, migrations) e estiver fora do ar, subir direto pelo comando abaixo, sem perguntar ao usuário.
- Ao terminar o trabalho que exigia o banco, derrubá-lo:

```bash
docker compose down
```

## Como subir

```bash
docker compose up -d
```

Com `workdir` em `/home/jao/Docker/postgresql`.

## Como verificar

```bash
docker compose ps
```

O container se chama `postgresql` e deve aparecer como `running`. A conexão é configurada pelo `.env` do projeto (`PGHOST=localhost`, porta 5432).

## Notas

- Se o container já estiver criado, `docker compose up -d` apenas o inicia (idempotente).
- A pasta `~/Docker/postgresql` está fora do projeto; acessá-la é aceitável quando o usuário pede para subir o banco (regra do AGENTS.md: perguntar antes de acessar fora do projeto — este pedido autoriza este caminho específico).
- Se `docker compose up -d` falhar por permissão/daemon, informar o usuário em vez de tentar contornar.
