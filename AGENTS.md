# Instructions

## Postura

- Atuar como um desenvolvedor sênior: decisões pragmáticas, código limpo e simples, sem over-engineering.

## Fluxo de trabalho (TDD)

- Antes de começar a mexer no código, dar `git pull` na `develop` e rodar `bundle install`.

- Sempre começar pela escrita do teste antes da implementação (red → green → refactor).
- Após terminar de implementar, sempre rodar os testes para validar a mudança antes de reportar concluído.
- Rodar também lint/typecheck quando disponível (ex.: `rubocop`, `rspec`).
- Ao final das implementações, mostrar as mudanças em diff lado a lado (ex.: `git difftool -y --extcmd 'diff -y'`) para revisão antes de reportar concluído.

## Estilo de código

- Evitar escrever código desnecessário: implementar apenas o que a tarefa pede, sem especulação.
- Não deixar comentários avulsos no código; o código deve ser autoexplicativo. Comentários só quando estritamente necessários e pedidos.
- Seguir as convenções existentes do projeto (Rails, RuboCop, estilo dos specs).

## Branches e commits

- Atualizações de gems ou qualquer outra coisa do sistema/ambiente devem ir em uma branch separada (ex.: `chore/atualizar`), subida sozinha — somente as atualizações, sem outras mudanças. Usar conventional commits.

## Modelagem de dados

- Antes de qualquer alteração de banco/modelagem (colunas, tabelas, relacionamentos, migrations), apresentar as opções de solução (prós/contras) e perguntar ao usuário para decidir antes de implementar.
## Comandos e ambiente do projeto

- Testes: `bundle exec rspec` (não existe `bin/rspec`).
- RuboCop: `bundle exec ruby "$(bundle show rubocop)/exe/rubocop"` — o `rubocop` do PATH é um shim do Mason que conflita com o bundle.
- App em pt-BR: os specs de feature esperam textos de UI em português (ex.: 'Entrar', 'Cadastrar-se').
- Specs de feature em português, às vezes deixados WIP pelo usuário; são a fonte de verdade (TDD).
- Ao acessar (ler, escrever ou listar) qualquer pasta fora do projeto, perguntar antes ao usuário.
- PRs são criados manualmente pelo usuário; o fluxo de "subir alterações" termina no push + link do PR (ver skill `subir-alteracoes`).

## Aprendizado contínuo

- Atualizar este arquivo sempre que aprender algo relevante sobre como o usuário escreve ou pede código (preferências, padrões, correções de rota).
- Planejamento do projeto: manter e consultar `.opencode/planejamento.md` (atualizá-lo conforme tarefas forem concluídas).
