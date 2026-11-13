require 'rails_helper'

feature 'gerenciar campanhas' do
  let(:user) { create(:user) }

  describe 'ver a campanha' do
    let(:campaign) { create(:campaign, master: 'Mestre boladão') }
    let!(:character) { create(:character, name: 'Yudmit Longfeet', user: user, campaign: campaign) }

    scenario 'exibe mestre, status, data e personagens' do
      logar_como user
      visit campaign_path(campaign)

      expect(page).to have_content 'Mestre boladão'
      expect(page).to have_content 'Ativa'
      expect(page).to have_content campaign.created_at.strftime('%d/%m/%Y')
      expect(page).to have_content character.name
    end
  end

  describe 'criar campanha' do
    scenario 'com sucesso' do
      logar_como user
      click_link 'Nova campanha'
      fill_in 'Mestre', with: 'Mestre boladão'
      click_button 'Criar campanha'

      expect(page).to have_content 'Campanha criada com sucesso.'
      expect(page).to have_content 'Mestre boladão'
    end

    scenario 'com mestre em branco mostra erro' do
      logar_como user
      click_link 'Nova campanha'
      click_button 'Criar campanha'

      expect(page).to have_content 'Não foi possível salvar a campanha.'
      expect(page).to have_content 'Mestre não pode ficar em branco'
    end
  end
end
