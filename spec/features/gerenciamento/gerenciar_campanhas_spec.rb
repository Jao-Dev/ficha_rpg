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

  describe 'editar campanha' do
    let(:master) { create(:user) }
    let(:campaign) { create(:campaign, master: master) }

    scenario 'com sucesso' do
      logar_como master
      visit campaign_path(campaign)
      click_link 'Editar'
      uncheck 'Ativa'
      click_button 'Atualizar campanha'

      expect(page).to have_content 'Campanha atualizada com sucesso.'
      expect(page).to have_content 'Inativa'
    end
  end

  describe 'excluir campanha' do
    let(:master) { create(:user) }
    let(:campaign) { create(:campaign, master: master) }

    scenario 'com sucesso' do
      logar_como master
      visit campaign_path(campaign)
      click_button 'Excluir'

      expect(page).to have_content 'Campanha excluída com sucesso.'
      within '.page-body' do
        expect(page).not_to have_content campaign.master.name
      end
    end

    scenario 'com personagens mostra erro' do
      character = create(:character, user: create(:user), campaign: campaign)

      logar_como master
      visit campaign_path(campaign)
      click_button 'Excluir'

      expect(page).to have_content 'Não foi possível excluir a campanha.'
      expect(page).to have_content character.name
    end
  end
end
