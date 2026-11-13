---
name: limpar-branches
description: Rotina de limpeza de branches do ficha_rpg — apagar remotamente e localmente as branches que já foram mergeadas na develop. Use ao trocar de branch, ao final de uma entrega mergeada ou quando o usuário pedir para limpar branches.
---

# Limpar branches mergeadas na develop

Regra do AGENTS.md: manter o ambiente limpo — ao trocar de branch, conferir se as outras já foram mergeadas na `develop`; se sim, apagá-las remotamente e localmente.

## Passo 1 — Atualizar referências

```bash
git fetch --prune origin
```

## Passo 2 — Listar mergeadas e não mergeadas

```bash
git branch -r --merged origin/develop | grep -v 'HEAD\|origin/main\|origin/develop'
git branch -r --no-merged origin/develop | grep -v 'HEAD\|origin/main\|origin/develop'
```

## Passo 3 — Apagar mergeadas

Para cada branch listada como mergeada (exceto as proteções abaixo):

```bash
git push origin --delete <branch>   # remota
git branch -d <branch>              # local (rodar a partir da develop)
```

## Proteções

- **Nunca** apagar `main`, `develop` ou a branch atual.
- **Nunca** apagar branches não mergeadas (`--no-merged`), incluídas as `dependabot/*` (são geridas pelo Dependabot).
- Se `git branch -d` recusar apagar (commits não mergeados), parar e perguntar ao usuário — não usar `-D` sem aprovação.
- Se uma branch mergeada remota estiver protegida no GitHub, informar o usuário em vez de insistir.

## Passo 4 — Conferência

```bash
git branch && git branch -r
```

Reportar o que foi apagado e o que ficou (e por quê).
