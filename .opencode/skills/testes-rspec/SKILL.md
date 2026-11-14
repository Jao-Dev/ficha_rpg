---
name: testes-rspec
description: Convenções e checklist de cobertura de testes RSpec do projeto ficha_rpg. Use ao criar, revisar ou refatorar qualquer spec em spec/ (models, features, request, policies) ou factories.
---

# Testes RSpec do ficha_rpg

Stack de testes: RSpec + FactoryBot + Faker + Capybara (selenium) + Devise + Audited + Pundit + Active Storage (via `active_storage_validations`).

## Convenções de escrita

- Sempre `require 'rails_helper'` no topo.
- `describe` direto com a classe, sem string e sem prefixo `RSpec.`:
  ```ruby
  describe Character do
  ```
- Descrições e mensagens **em português**: `describe 'Validacoes' do`, `it 'sem email' do`, `scenario 'logar com sucesso' do`.
- Specs de model em `spec/models/<model>_spec.rb`; specs de feature em `spec/features/` usando `feature '...'` + `scenario '...'` (não `describe`/`it`).
- Dados dos cenários de feature com `let`/`let!` no topo da `feature` (não `create` dentro do scenario):
  - `let` para o que só fornece valores (ex.: `user`);
  - `let!` para dados que precisam existir **antes** da ação do cenário (ex.: personagens que devem aparecer na página) — `let` é lazy e criaria depois da navegação;
  - variáveis de usuário com role específica levam o nome do papel (ex.: `admin`, `master`), não `user`;
  - nomes explícitos nos registros que podem colidir (a factory `:character` usa nome fixo).
- `let` que servem a vários `describe` sobem para o bloco principal; cada `describe` só sobrescreve o que muda (inclusive `subject` quando o papel do usuário muda):
  ```ruby
  describe MembershipPolicy do
    subject(:policy) { described_class.new(user, membership) }
    let(:user) { create(:user) }
    let(:membership) { create(:membership) }
- Fluxos repetidos de navegação ficam no `spec/support/feature_helpers.rb` (ex.: `logar_como`) ou, se muito específicos, em métodos `private` dentro do arquivo.
- Validações de presença em uma linha com o matcher do gem `valid_attribute`:
  ```ruby
  it { is_expected.not_to have_valid(:name).when(nil, '') }
  ```
- Fluxos repetidos de navegação ficam no `spec/support/feature_helpers.rb` (ex.: `logar_como`) ou, se muito específicos, em métodos `private` dentro do arquivo.
- Factories centralizadas em `spec/factories.rb` (não criar `spec/factories/*.rb`). Usar Faker para dados genéricos e `trait` para estados alternativos (ex.: `trait :inativo`).
- Helpers de front-end: `card`, `alert` e `btn` do `UiHelper` para estrutura de página; `TablerFormBuilder` (padrão global) já aplica as classes Tabler — não repetir `form-label`/`form-control` nos formulários de `form_with`.
- Arquivos dummy para upload ficam em `spec/resources/dummies/` (ex.: `dummy.png`, `dummy.heic`, `dummy.pdf`, `dummy.txt`) e arquivos sem extensão em `spec/resources/`. Imagens válidas para avatar/testes também podem vir de `spec/resources/` (ex.: `pingu_comunista.png`).
- Anexar arquivos de Active Storage assim:
  ```ruby
  character.avatar.attach(
    io: Rails.root.join('spec/resources/dummies/dummy.png').open,
    filename: 'dummy.png'
  )
  ```
- `spec_helper.rb` exige `capybara/rspec`; `rails_helper.rb` inclui `FactoryBot::Syntax::Methods` — usar `build`/`create` direto.

## Checklist de cobertura ao criar novos testes

Para cada model/funcionalidade nova, cobrir (quando aplicável):

### Models (`spec/models/`)
- [ ] Validações de presença de **todos** os campos obrigatórios com `have_valid(...).when(nil, '')`
- [ ] Caso "criando novo <recurso>" com campo ausente usando `build` e `expect(u).not_to be_valid`
- [ ] Validações de formato/formato de email (`valid_email`), unicidade e tamanho, se existirem no model
- [ ] Validações de Active Storage: content types aceitos (`ACCEPTED_CONTENT_TYPES` — png/jpeg) e conteúdo inválido rejeitado (heic, pdf, txt, arquivo sem extensão) — ver `spec/models/character_spec.rb`
- [ ] Validação de arquivo válido: attach de imagem aceita e registro `be_valid` + anexo não nulo
- [ ] Associações (`belongs_to :user`, `belongs_to :campaign`, etc.) — registro inválido quando associação obrigatória ausente
- [ ] Enums/booleanos: testar valores válidos e inválidos de `ativo`
- [ ] `audited`: se o model é auditado, cobrir que ações criam registros de auditoria quando o padrão do projeto exigir

### Features (`spec/features/`)
- [ ] Página/renderização inicial (conteúdo esperado na tela)
- [ ] Fluxo principal com sucesso (login, cadastro, CRUD) e mensagem de confirmação exibida
- [ ] Fluxo de logout
- [ ] Cadastro/criação de recursos pelo formulário (`fill_in`, `click_button`)
- [ ] Validação exibida ao enviar formulário inválido

### Policies / autorização (quando houver, com `pundit-matchers`)
- [ ] Permissões por papel/ação com `permit_actions`, `permit_edit_and_update_actions`, etc.

### Boas práticas
- [ ] Não depender de ordem de execução; cada spec cria seus próprios dados via factories
- [ ] `build` (não `create`) quando só valida o objeto em memória
- [ ] Rodar a suíte antes de entregar: `bundle exec rspec` (arquivo específico: `bundle exec rspec spec/models/user_spec.rb`)
