# TablerFormBuilder

Form builder padrão do projeto (`app/builders/tabler_form_builder.rb`), configurado em `config/application.rb` via `config.action_view.default_form_builder`. Todo `form_with` já o usa — não é preciso passar `builder:`.

## O que ele aplica automaticamente

| Método | Classe adicionada |
|---|---|
| `label` | `form-label` |
| `text_field`, `email_field`, `password_field`, `file_field` | `form-control` |
| `collection_select` | `form-select` |
| `submit` | `btn btn-primary` |

Classes extras passadas em `class:` são **somadas** à classe padrão, não substituídas:

```haml
= f.text_field :name                          # form-control
= f.text_field :name, class: 'is-invalid'     # form-control is-invalid
```

## Exemplo de formulário

```haml
= form_with model: [ character.user, character ] do |f|
  - if character.errors.any?
    = alert('danger') do
      %ul.mb-0
        - character.errors.full_messages.each do |message|
          %li= message

  .mb-3
    = f.label :name
    = f.text_field :name

  .d-flex
    .ms-auto
      = f.submit character.new_record? ? 'Criar personagem' : 'Atualizar personagem'
```

## Notas

- As views do Devise usam `simple_form_for` e seguem com o builder do `simple_form` — o `TablerFormBuilder` não os afeta.
- Novos métodos de campo (ex.: `select`, `date_field`) devem ser adicionados ao builder com a classe Tabler correspondente, em vez de passar `class:` na view.
