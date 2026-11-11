---
name: subir-alteracoes
description: Rotina para subir alterações do projeto — branch separada, commits e push. Use quando o usuário pedir para commitar, subir ou criar branch.
---

# Subir alterações do ficha_rpg

Nunca commitar direto em `develop` ou `main`. Sempre criar branch separada (PR para `develop` é feito manualmente pelo usuário, não pelo opencode).

## Passo 1 — Diagnóstico (sempre primeiro)

```bash
git status && git branch --show-current && git remote -v && git log --oneline -5
git diff   # revisar o que mudou em arquivos rastreados
```

- Conferir cada arquivo modificado; se houver alteração que você não fez, verificar o diff e perguntar ao usuário antes de incluir.
- Se o working tree estiver limpo, não há o que subir — reportar e encerrar.

## Passo 2 — Branch

- Criar a partir de `develop`: `git checkout -b <nome>`.
- Convenção do repo: lowercase com underscore, prefixo por natureza — `feat/autenticacao_devise`, `chore/atualizar`.

## Passo 3 — Commits

- Mensagens em português, estilo conventional commits: `feat: ...`, `chore: ...`.
- Separar por natureza quando fizer sentido (ex.: um commit `feat` com código e um `chore` com docs/meta).
- `git add` por grupos (nunca `git add .` às cegas): código, depois docs.
- Os hooks do lefthook podem rodar lint/validação no commit; se falharem, corrigir e criar novo commit.

## Passo 4 — Push

```bash
git push -u origin <branch>
```

## Passo 5 — Finalizar

- **Não criar PR** — o usuário prefere fazê-lo manualmente.
- Reportar: branch criada, commits feitos e o link sugerido pelo remote para abrir o PR (`https://github.com/Jao-Dev/ficha_rpg/pull/new/<branch>`).
