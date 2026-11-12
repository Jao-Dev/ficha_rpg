require 'rails_helper'

feature 'acesso restrito' do
  scenario 'visitante não acessa a ficha de um personagem' do
    character = create(:character)

    visit user_character_path(character.user, character)

    expect(page).to have_content 'Entrar'
  end

  scenario 'visitante não acessa uma campanha' do
    campaign = create(:campaign)

    visit campaign_path(campaign)

    expect(page).to have_content 'Entrar'
  end
end
