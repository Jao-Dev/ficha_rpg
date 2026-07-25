# Ideia

A ideia é aprender ruby com um projeto do zero e fluxo de trabalho com TDD no desenvolvimento e fluxo de trabalho básico no git com PR e revisão.

Criação de um projeto de ficha de rpg na linguagem ruby que:

1. Tenha criação de conta;
    1. Mande e-mail de confirmação;
    2. Tenha recuperação de senha.
2. Tenha mais de um personagem por usuário;
    1. Possa alternar entre eles (perfis diferentes);
    2. Colunas: **nome, email**
3. Cada personagem estará vinculado a uma campanha;
    1. Colunas: **nome, raça, foto (has_one_attached), campanha_id (belongs_to), user_id (belongs_to)**
    2. Cada personagem tem uma foto (Active Storage).
        
        ```ruby
        string 'nome', null: false
        string 'raca', null: false
        bigint 'campanhas_id', null: false
        bigint 'user_id', null: false
        boolean 'ativo', default: true, null: false
        ```
        
4. A campanha estará vinculada a vários personagens;
    1. Colunas: **mestre, data_de_criação, jogadores (has_many)**
        
        ```ruby
        string 'mestre', null: false
        datetime 'created_at', precision: nil, null: false
        
        add_foreign_key 'jogadores', 'campanhas' (acho q é isso)
        ```
        
5. Ideias de gems para usar:
    
    ```ruby
    # security
    gem 'audited'
    gem 'devise'
    gem 'pundit'
    
    # javascript
    gem 'stimulus-rails'
    gem 'turbo-rails'
    
    # support
    gem 'anyway_config'
    gem 'haml-rails'
    gem 'simple_form'
    
    # infrastructure support'
    gem 'strong_migrations'
    
    # project specifics
    gem 'active_storage_validations'
    gem 'valid_email'
    
    # :test, :development
     gem 'capybara'
     gem 'dotenv-rails'
     gem 'factory_bot_rails'
     gem 'faker'
     gem 'haml_lint', require: false
     gem 'pry-rails'
     gem 'pundit-matchers'
     gem 'rspec-rails'
     gem 'rubocop'
     gem 'valid_attribute'
     
    # :development
     gem 'better_errors'
     gem 'dead_end'
     gem 'letter_opener'
     gem 'ruby-lsp-rspec'
     gem 'ruby-lsp', require: false
    ```
    
6. Banco de dados **PostgreSQL**
    1. compose.yml
        
        ```ruby
        services:
          postgres:
            image: postgres:18-alpine
            container_name: postgresql
            restart: always
            environment:
              POSTGRES_USER: postgres
              POSTGRES_PASSWORD: password
              POSTGRES_DB: mydatabase
            ports:
              - "5432:5432"
            volumes:
              - postgres-data:/var/lib/postgresql
        
        volumes:
          postgres-data:
        ```
