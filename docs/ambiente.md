# Ambiente e comandos

Requisitos: Ruby (via mise), PostgreSQL em Docker, bundle instalado.

## Banco de dados

PostgreSQL roda em Docker Compose, em `~/Docker/postgresql`:

```bash
cd ~/Docker/postgresql && docker compose up -d   # subir
cd ~/Docker/postgresql && docker compose down    # derrubar
```

A conexão vem do `.env` do projeto (`PGHOST=localhost`, porta 5432).

## Testes

```bash
bundle exec rspec                        # suite completa
bundle exec rspec spec/models/user_spec.rb   # arquivo específico
```

## Lint

```bash
bundle exec ruby "$(bundle show rubocop)/exe/rubocop"   # o rubocop do PATH é um shim que conflita com o bundle
bundle exec haml-lint app/views
```

## Assets

- Tabler é vendored: CSS em `app/assets/stylesheets/tabler.min.css` e JS em `vendor/javascript/tabler.min.js` (importmap). Sem CDN em runtime.
- `public/assets/.manifest.json` (precompile) é commitado e o Propshaft resolve por ele. **Ao adicionar assets novos, rodar `bin/rails assets:precompile`** — manifest desatualizado quebra o carregamento em dev/teste.
