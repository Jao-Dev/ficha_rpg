require 'rails_helper'

feature 'acesso restrito' do
  let!(:character) { create(:character) }
  let!(:campaign) { create(:campaign) }
  let(:outro_usuario) { create(:user) }

  scenario 'visitante não acessa a ficha de um personagem' do
    visit user_character_path(character.user, character)

    expect(page).to have_content 'Entrar'
  end

  scenario 'visitante não acessa uma campanha' do
    visit campaign_path(campaign)

    expect(page).to have_content 'Entrar'
  end

  scenario 'usuário não acessa a ficha de personagem de outro usuário' do
    logar_como outro_usuario
    visit user_character_path(character.user, character)

    expect(page).to have_content 'Você não tem acesso a esta página.'
    expect(page).not_to have_content character.name
  end

  scenario 'usuário não edita personagem de outro usuário' do
    logar_como outro_usuario
    visit edit_user_character_path(character.user, character)

    expect(page).to have_content 'Você não tem acesso a esta página.'
  end

  scenario 'mestre da campanha vê a ficha do personagem' do
    mestre = create(:user)
    campanha_do_mestre = create(:campaign, master: mestre)
    personagem = create(:character, user: create(:user), campaign: campanha_do_mestre)

    logar_como mestre
    visit user_character_path(personagem.user, personagem)

    expect(page).to have_content personagem.name
  end
end
