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
- **Characters**: tabela com `name/race/ativo` + FKs `user/campaign`; `has_one_attached :avatar` e validações de content-type no model (checar typo `spoofin_protection` — deveria ser `spoofing_protection`?). `root` agora é `characters#index` listando os personagens do usuário logado (`authenticate_user!` + `has_many :characters` no User).
- **Campaigns**: tabela com `master/ativo`.
- **Controllers**: `UsersController` (index/create/update/destroy vazios), `CharactersController` (index implementado; show/create/update/destroy vazios), `CampaignsController` (show/create vazios) — campaigns ainda sem `authenticate_user!`.
- **Pundit**: instalado, só `ApplicationPolicy` — sem policies de domínio.
- **Views**: devise pt-BR, `characters/index` (lista de nomes), `users/index` (placeholder "Logado com sucesso!") e `users/show` vazio. Faltam telas de ficha do personagem/campanha.
- **Rotas**: `root "characters#index"`; `resources :users` → `characters` (show/create/update/destroy); `resources :campaigns` (show/create).

## Backlog (ordem sugerida — TDD)

1. ~~**Rotas/controllers**: decidir `root` (decidido: `characters#index`)~~; proteger `CampaignsController` com `authenticate_user!`.
2. **Personagem**: specs para show/create/update/destroy + views (ficha do personagem, upload de avatar com Active Storage).
3. **Campanha**: specs para show/create + views (mestre, data, status, lista de personagens/jogadores).
4. **Pundit**: policies de acesso (páginas e modificação de personagens — dono vs mestre).
5. **Devise**: ativar `:confirmable` + mailer de confirmação; specs de recuperação de senha.
6. **Alternância de personagens** (perfis): seleção do personagem ativo por sessão.

## Convenções do projeto

- pt-BR na UI e nos specs de feature; specs são a fonte de verdade (TDD).
- Testes: `bundle exec rspec`; RuboCop: `bundle exec ruby "$(bundle show rubocop)/exe/rubocop"`.
- Sem over-engineering; código autoexplicativo, sem comentários avulsos.
