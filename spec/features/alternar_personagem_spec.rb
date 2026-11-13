require 'rails_helper'

feature 'alternar personagem em uso' do
  let(:user) { create(:user) }
  let(:campaign) { create(:campaign) }
  let!(:character) { create(:character, user: user, campaign: campaign, race: 'Anão') }
  let!(:outro) { create(:character, user: user, campaign: campaign, name: 'Belerion') }

  describe 'sem personagem em uso' do
    scenario 'o seletor mostra só o nome do usuário' do
      logar_como user
      visit root_path

      expect(page).to have_content user.name
      expect(page).not_to have_content '(Belerion)'
      expect(page).not_to have_content '(Yudmit Longfeet)'
    end
  end

  describe 'selecionando um personagem no seletor' do
    scenario 'mostra o personagem entre parênteses no header' do
      logar_como user
      visit root_path
      find('summary', text: user.name).click
      click_button 'Belerion'

      expect(page).to have_content 'Você agora está usando Belerion.'
      expect(page).to have_content '(Belerion)'
    end

    scenario 'alternando para outro personagem troca o em uso' do
      logar_como user
      visit root_path
      find('summary', text: user.name).click
      click_button 'Belerion'
      find('summary', text: user.name).click
      click_button 'Yudmit Longfeet'

      expect(page).to have_content 'Você agora está usando Yudmit Longfeet.'
      expect(page).to have_content '(Yudmit Longfeet)'
    end
  end

  describe 'logout' do
    scenario 'limpa a seleção' do
      logar_como user
      visit root_path
      find('summary', text: user.name).click
      click_button 'Belerion'
      click_button 'Log out'

      logar_como user
      visit root_path

      expect(page).not_to have_content '(Belerion)'
    end
  end
end
