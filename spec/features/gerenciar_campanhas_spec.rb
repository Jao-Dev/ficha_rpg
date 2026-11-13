require 'rails_helper'

feature 'gerenciar campanhas' do
  let(:user) { create(:user) }

  describe 'ver a campanha' do
    let(:master) { create(:user, name: 'Mestre boladão') }
    let(:campaign) { create(:campaign, master: master) }
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
    scenario 'com sucesso e o criador se torna o mestre' do
      logar_como user
      click_button 'Nova campanha'

      expect(page).to have_content 'Campanha criada com sucesso.'
      expect(page).to have_content user.name
    end
  end
end
