# UiHelper

Helpers de estrutura de página no padrão Tabler (`app/helpers/ui_helper.rb`). Incluído automaticamente em todas as views.

## `card`

Card com header (título e, opcionalmente, ações) e corpo via bloco.

```haml
= card 'Seus personagens' do
  .card-body
    %p Conteúdo do card
```

Com ações no header — um botão ou uma lista (renderizados à direita):

```haml
= card 'Nova campanha' do
  .card-body
    = render 'form', campaign: @campaign

= card @character.name,
  actions: [ btn('Editar', edit_user_character_path(@character.user, @character), style: 'outline-primary'),
             btn('Excluir', user_character_path(@character.user, @character),
               style: 'outline-danger', method: :delete, confirm: 'Deseja excluir o personagem?') ] do
  .card-body
    %p= @character.race
```

## `alert`

Alerta Tabler. `kind` é a cor (`success`, `danger`, ...). Aceita mensagem direta ou bloco (para listas de erro):

```haml
= alert('success', 'Campanha criada com sucesso.')

= alert('danger') do
  %ul.mb-0
    - record.errors.full_messages.each do |message|
      %li= message
```

No layout, o flash é mapeado assim: `notice` → `alert-success`, qualquer outro tipo → `alert-danger`.

## `btn`

Botão pequeno (`btn btn-* btn-sm`). É `link_to` por padrão; com `method`, vira `button_to` (e aceita `confirm`):

```haml
= btn 'Novo personagem', new_user_character_path(current_user)
= btn 'Nova campanha', new_campaign_path, style: 'outline-primary'
= btn 'Log out', destroy_user_session_path, style: 'outline-secondary', method: :delete
= btn 'Excluir', user_character_path(user, character),
  style: 'outline-danger', method: :delete, confirm: 'Deseja excluir o personagem?'
```

## Regra de uso

Views **não** devem escrever markup Tabler solto (`.card`, `.alert`, `btn btn-*` na mão). Se um componente novo for recorrente (ex.: tabela, badge), adicione um método ao `UiHelper` em vez de copiar HTML.
