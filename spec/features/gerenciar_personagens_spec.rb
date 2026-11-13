require 'rails_helper'

feature 'gerenciar personagens' do
  scenario 'ver a ficha do personagem' do
    user = create(:user)
    campaign = create(:campaign, master: 'Mestre boladão')
    character = create(:character, user: user, campaign: campaign, race: 'Anão')
    character.avatar.attach(
      io: Rails.root.join('spec/resources/dummies/dummy.png').open,
      filename: 'dummy.png'
    )

    logar_como user
    visit user_character_path(user, character)

    expect(page).to have_content character.name
    expect(page).to have_content 'Anão'
    expect(page).to have_content 'Mestre boladão'
    expect(page).to have_css("img[src*='dummy.png']")
  end

  scenario 'criar personagem com foto' do
    user = create(:user)
    campaign = create(:campaign)

    logar_como user
    click_link 'Novo personagem'
    fill_in 'Nome', with: 'Yudmit Longfeet'
    fill_in 'Raça', with: 'Anão'
    select campaign.master, from: 'Campanha'
    attach_file 'Foto', Rails.root.join('spec/resources/dummies/dummy.png')
    click_button 'Criar personagem'

    expect(page).to have_content 'Yudmit Longfeet'
    expect(page).to have_content 'Anão'
    expect(page).to have_css("img[src*='dummy.png']")
  end

  scenario 'criar personagem com campos obrigatórios em branco mostra erros' do
    user = create(:user)

    logar_como user
    click_link 'Novo personagem'
    click_button 'Criar personagem'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Raça não pode ficar em branco'
  end

  scenario 'criar personagem com foto inválida mostra erro' do
    user = create(:user)
    create(:campaign)

    logar_como user
    click_link 'Novo personagem'
    fill_in 'Nome', with: 'Yudmit Longfeet'
    fill_in 'Raça', with: 'Anão'
    attach_file 'Foto', Rails.root.join('spec/resources/dummies/dummy.pdf')
    click_button 'Criar personagem'

    expect(page).to have_content 'deve ser uma imagem PNG ou JPEG'
  end

  scenario 'editar personagem' do
    user = create(:user)
    character = create(:character, user: user, race: 'Anão')

    logar_como user
    visit user_character_path(user, character)
    click_link 'Editar'
    fill_in 'Raça', with: 'Elfo'
    click_button 'Atualizar personagem'

    expect(page).to have_content 'Personagem atualizado com sucesso.'
    expect(page).to have_content 'Elfo'
    expect(page).not_to have_content 'Anão'
  end

  scenario 'editar personagem com dados inválidos mostra erro' do
    user = create(:user)
    character = create(:character, user: user)

    logar_como user
    visit user_character_path(user, character)
    click_link 'Editar'
    fill_in 'Nome', with: ''
    click_button 'Atualizar personagem'

    expect(page).to have_content 'Não foi possível salvar o personagem.'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  scenario 'excluir personagem' do
    user = create(:user)
    character = create(:character, user: user)

    logar_como user
    visit user_character_path(user, character)
    click_button 'Excluir'

    expect(page).not_to have_content character.name
    expect(page).to have_content 'Personagem excluído com sucesso.'
  end
end
