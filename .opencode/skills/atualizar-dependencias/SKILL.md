---
name: atualizar-dependencias
description: Rotina de atualização de dependências do projeto (Ruby via mise, Rails e demais gems do Gemfile). Use quando o usuário pedir para atualizar gems, Ruby, Rails, dependências ou Gemfile.
---

# Atualizar dependências do ficha_rpg

Ordem obrigatória: **Ruby (mise) → Rails → demais gems**. Nunca pegar versão beta/pré-release/rc/dev. Se uma gem conflitar, deixá-la na versão atual (pin) e reportar ao usuário.

## Passo 1 — Diagnóstico (sempre primeiro)

Antes de alterar qualquer coisa, rodar um comando que mostre o que há para atualizar:

```bash
# Ruby: versão atual vs última estável
mise current ruby && mise ls-remote ruby | grep -v -- '-' | grep -vE 'rc|dev|preview' | tail -5

# Rails e gems: últimas versões estáveis disponíveis
gem list -r -e rails propshaft pg puma importmap-rails turbo-rails stimulus-rails jbuilder solid_cache solid_queue solid_cable bootsnap kamal thruster image_processing audited devise pundit anyway_config haml-rails simple_form strong_migrations active_storage_validations valid_email debug bundler-audit brakeman rubocop-rails-omakase capybara dotenv-rails factory_bot_rails faker haml_lint pry-rails pundit-matchers rspec-rails rubocop selenium-webdriver valid_attribute web-console better_errors dead_end letter_opener ruby-lsp-rspec ruby-lsp lefthook binding_of_caller

# Versões atualmente travadas no projeto
rg '^\s+(rails|pg|image_processing|puma) \(' Gemfile.lock
```

Comparar com o `Gemfile.lock` e montar a lista do que mudou.

## Passo 2 — Pedir autorização

Apresentar a lista ao usuário e **só atualizar após confirmação explícita**.

## Passo 3 — Ruby (mise)

- Última estável = maior número de patch sem sufixo (`4.0.9`, nunca `4.1.0-rc1`).
- Instalar e definir: `mise install ruby@<versão> && mise use -g ruby@<versão>`
- Atualizar também o `.ruby-version` do projeto (existe arquivo com `ruby-x.y.z`).
- **Atenção**: a sessão do opencode pode ter PATH antigo em cache. Em cada comando, exportar o PATH do Ruby novo antes de rodar bundler:
  ```bash
  export PATH="/home/jao/.local/share/mise/installs/ruby/<versão>/bin:/home/jao/.local/share/mise/shims:$PATH"
  ```
  Confirmar com `ruby -v` antes de qualquer `bundle`.

## Passo 4 — Rails no Gemfile

- Consultar última estável: `gem list -r -e rails`
- Atualizar a constraint no Gemfile (ex.: `~> 8.1.4`) e rodar `bundle update rails`.

## Passo 5 — Demais gems

- Ajustar as constraints do Gemfile que estiverem desatualizadas (ex.: `pg ~> 1.7`).
- Gems sem constraint já pegam a última: `bundle update --all` (ou `bundle update <gem1> <gem2>` para alvo específico).
- Se o bundler reportar conflito de versão entre gems, testar alternativas; se não resolver, **manter a gem na versão atual** (não atualizar) e informar o motivo ao usuário.
- Gems instaladas com extensão nativa precisam ser reinstaladas sob o Ruby novo (`bundle install` garante isso).

## Passo 6 — Validação

```bash
bundle exec rails zeitwerk:check
bundle exec rails runner 'puts "Rails #{Rails.version} / Ruby #{RUBY_VERSION}"'
bundle exec rspec 2>&1 | tail -5
```

- Suíte precisa carregar sem erro de versão/zeitwerk. Falhas pré-existentes de specs devem ser reportadas como tais (comparar antes/depois se necessário).
- Resumo final: Ruby (x → y), Rails (x → y), gems atualizadas (lista), gems travadas por conflito (lista), resultado da suíte.
