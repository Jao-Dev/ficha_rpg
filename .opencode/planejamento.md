# Planejamento — ficha_rpg

Arquivo de trabalho do opencode. Fonte original: "Projeto ficha_rpg (ruby) 3a89fb94.md" (excluído após consolidação).

## Objetivo do projeto

Ficha de RPG em Ruby/Rails:
1. Conta com e-mail de confirmação e recuperação de senha (Devise).
2. Vários personagens por usuário; possibilidade de alternar entre eles.
3. Personagem: **nome, raça, foto (Active Storage), campanha_id, user_id, ativo**.
4. Campanha: **mestre, data de criação, ativo**; vinculada a vários personagens (jogadores).
5. Banco: **PostgreSQL** (o doc original tinha um compose.yml; hoje a conexão é via `.env`).

## Estado atual (verificado em 12/11/2026)

- **Devise**: login, cadastro e logout funcionando (specs verdes), com UI pt-BR e controller custom `Users::SessionsController`. Pendente: ativar `:confirmable` (e-mail de confirmação) e specs para recuperação de senha (`:recoverable` já no model).
- **Rotas/root**: `root users#index` (lista de personagens do usuário logado); `users` restrito a `only: :index`; `CharactersController` e `CampaignsController` protegidos por `authenticate_user!`. Characters agora com `new/create/show/edit/update/destroy`.
- **Characters**: CRUD completo com specs de feature verdes (ficha, criar com foto, erros de validação, editar, excluir). Flash de sucesso/erro em create/update/destroy. Avatar anexável via formulário. Por ora só o dono acessa (`current_user.characters.find`).
- **Front-end (padrão Tabler + helpers)**: Tabler 1.7.5 vendored (sem CDN): `app/assets/stylesheets/tabler.min.css` (incluído em lote pelo `stylesheet_link_tag :app` do Propshaft 1.3) e `vendor/javascript/tabler.min.js` (importmap pin "tabler"). `UiHelper` (`app/helpers/ui_helper.rb`) com `card(title, actions:) { }`, `alert(kind) { }` e `btn(label, path, style:, method:, confirm:)`; `TablerFormBuilder` (`app/builders/`) é o form builder padrão (`config.action_view.default_form_builder`) e aplica `form-label`/`form-control`/`form-select`/`btn btn-primary` sozinho — views não repetem classes. Devise segue com simple_form (não afetado).
- **Views**: 100% Haml — nenhum `.erb` no projeto (Devise, layouts, mailers e PWA convertidos). `.haml-lint.yml`: LineLength 120, IdNames off (convenção do Devise).
- **Cuidado com assets**: `public/assets/.manifest.json` é precompile commitado; o Propshaft resolve por ele — ao adicionar assets novos, rodar `bin/rails assets:precompile` (havia manifest velho de agosto que quebrou o load do Tabler).
- **Campaigns**: tabela com `master/ativo`.
- **Pundit**: instalado, só `ApplicationPolicy` — sem policies de domínio.
- **Specs helpers**: `logar_como` em `spec/support/feature_helpers.rb` (auto-requerido pelo rails_helper). Locale pt-BR de attributes do Character em `config/locales/pt-BR.yml`.
- **CI e cobertura**: SimpleCov configurado em `spec/spec_helper.rb` (piso de 100% linhas/branches) e script `./ci.sh` (RuboCop + RSpec + cobertura) — rodar antes de subir alterações.

## Backlog (ordem sugerida — TDD)

1. ~~Rotas/controllers~~ (concluído em 12/11/2026).
2. ~~Personagem (ficha, CRUD, avatar)~~ (concluído em 12/11/2026).
3. ~~Campanha (show/create + views)~~ (concluído em 12/11/2026).
4. **Pundit**: policies de acesso (páginas e modificação de personagens — dono vs mestre).
5. **Devise**: ativar `:confirmable` + mailer de confirmação; specs de recuperação de senha; (opcional) padronizar telas do Devise com Tabler.
6. **Alternância de personagens** (perfis): seleção do personagem ativo por sessão.

## Convenções do projeto

- pt-BR na UI e nos specs de feature; specs são a fonte de verdade (TDD).
- Testes: `bundle exec rspec`; RuboCop: `bundle exec ruby "$(bundle show rubocop)/exe/rubocop"`.
- Sem over-engineering; código autoexplicativo, sem comentários avulsos.
