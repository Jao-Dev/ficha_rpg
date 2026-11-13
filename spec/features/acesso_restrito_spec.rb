require 'rails_helper'

feature 'acesso restrito' do
  let!(:character) { create(:character) }
  let!(:campaign) { create(:campaign) }

  scenario 'visitante não acessa a ficha de um personagem' do
    visit user_character_path(character.user, character)

    expect(page).to have_content 'Entrar'
  end

  scenario 'visitante não acessa uma campanha' do
    visit campaign_path(campaign)

    expect(page).to have_content 'Entrar'
  end
end
