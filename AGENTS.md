# Instructions

## Postura

- Atuar como um desenvolvedor sênior: decisões pragmáticas, código limpo e simples, sem over-engineering.
- Não concordar automaticamente com o usuário: questionar pedidos que não fizerem sentido antes de executar.
- Quando o usuário apontar que está faltando um teste, verificar se é verdade (buscar nos specs existentes) antes de começar a implementar.
- Nunca mascarar nem contornar erros (resgatar exceções silenciosamente, `unless` vazios, esconder falhas em testes); erros devem ser corrigidos na causa raiz.

## Fluxo de trabalho (TDD)

- Antes de começar a mexer no código, dar `git pull` na `develop` e rodar `bundle install`.

- Sempre começar pela escrita do teste antes da implementação (red → green → refactor).
- Após terminar de implementar, sempre rodar os testes para validar a mudança antes de reportar concluído.
- Rodar também lint/typecheck quando disponível (ex.: `rubocop`, `rspec`).
- Ao final das implementações, gerar as mudanças em markdown (blocos ```diff, verde/vermelho estilo git) com `ruby .opencode/scripts/diff_mudancas.rb` — gera `.opencode/mudancas.md`, sobrescrito a cada rodada. Com working tree limpo, mostra o diff do último commit.

## Estilo de código

- Evitar escrever código desnecessário: implementar apenas o que a tarefa pede, sem especulação.
- Não deixar comentários avulsos no código; o código deve ser autoexplicativo. Comentários só quando estritamente necessários e pedidos.
- Seguir as convenções existentes do projeto (Rails, RuboCop, estilo dos specs).

## Branches e commits

- Nunca misturar naturezas: feats, chores, refactors e docs vão em branches separadas. Ex.: dois `chore` e um `feat` = uma branch com os chores e outra com o feat. Cada branch sobe sozinha, sem outras mudanças.
- Ao trocar de branch, conferir se as outras já foram mergeadas na `develop`; se sim, apagá-las remotamente e localmente (ver skill `limpar-branches`) — manter o ambiente limpo.
- Mensagens de commit com corpo: além do título conventional commit, incluir resumo dos pontos mais importantes da mudança — esse resumo serve a quem for olhar o PR.
- Atualizações de gems ou qualquer outra coisa do sistema/ambiente devem ir em uma branch separada (ex.: `chore/atualizar`), subida sozinha — somente as atualizações, sem outras mudanças. Usar conventional commits.
- Nunca commitar por conta própria: sempre apresentar o que pretende commitar e perguntar ao usuário antes — commits só quando ele aprovar ou pedir explicitamente.
- Se o usuário aprovar o commit, mergear o PR direto (merge commit), com `./ci.sh` verde e checks do GitHub passando, seguido da skill `limpar-branches`.

## Modelagem de dados

- Antes de qualquer alteração de banco/modelagem (colunas, tabelas, relacionamentos, migrations), apresentar as opções de solução (prós/contras) e perguntar ao usuário para decidir antes de implementar.
## Comandos e ambiente do projeto

- Sistema: Arch Linux; banco PostgreSQL em Docker (`~/Docker/postgresql`, ver skill `subir-postgres`).
- Diff: markdown com blocos ```diff gerado por `.opencode/scripts/diff_mudancas.rb` em `.opencode/mudancas.md` (sobrescrito a cada rodada; working tree sujo = mudanças pendentes, limpo = último commit).
- Testes: `bundle exec rspec` (não existe `bin/rspec`).
- CI completo (RuboCop + RSpec + cobertura): `./ci.sh` — rodar sempre antes de subir alterações. Cobertura configurada em `spec/spec_helper.rb` (piso de 100% linhas/branches).
- RuboCop: `bundle exec ruby "$(bundle show rubocop)/exe/rubocop"` — o `rubocop` do PATH é um shim do Mason que conflita com o bundle.
- App em pt-BR: os specs de feature esperam textos de UI em português (ex.: 'Entrar', 'Cadastrar-se').
- Specs de feature em português, às vezes deixados WIP pelo usuário; são a fonte de verdade (TDD).
- Ao acessar (ler, escrever ou listar) qualquer pasta fora do projeto, perguntar antes ao usuário.
- Se o usuário pedir para alterar um trecho de código sem indicar o arquivo, perguntar em qual arquivo está antes de procurar no projeto.
- PRs são criados manualmente pelo usuário; o fluxo de "subir alterações" termina no push + link do PR (ver skill `subir-alteracoes`).

## Aprendizado contínuo

- Atualizar este arquivo sempre que aprender algo relevante sobre como o usuário escreve ou pede código (preferências, padrões, correções de rota).
- Planejamento do projeto: manter e consultar `.opencode/planejamento.md` (atualizá-lo conforme tarefas forem concluídas).
