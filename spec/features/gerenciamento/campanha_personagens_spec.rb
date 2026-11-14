require 'rails_helper'

feature 'personagens da campanha' do
  let(:master) { create(:user) }
  let(:campaign) { create(:campaign, master: master) }

  describe 'mestre adiciona personagem' do
    let!(:dono) { create(:user, name: 'Dono Um') }
    let!(:personagem) { create(:character, name: 'Belerion', user: dono) }

    scenario 'busca por nome, agrupa por usuário e adiciona como pendente' do
      logar_como master
      visit edit_campaign_path(campaign)
      fill_in 'Personagem', with: 'Belerion'
      click_button 'Buscar'

      expect(page).to have_content 'Dono Um'
      expect(page).to have_content 'Belerion'
      click_button 'Adicionar'

      expect(page).to have_content 'Personagem adicionado. Aguardando confirmação do dono.'
      expect(page).to have_content 'Belerion'
      expect(page).to have_content 'Pendente'
    end

    scenario 'não lista personagens que já estão em campanha' do
      create(:character, name: 'Yudmit Longfeet', user: dono, campaign: campaign)

      logar_como master
      visit edit_campaign_path(campaign)
      fill_in 'Personagem', with: 'Yudmit'
      click_button 'Buscar'

      expect(page).not_to have_button 'Adicionar'
    end
  end

  scenario 'mestre não adiciona personagem que já está em campanha' do
    dono = create(:user)
    personagem = create(:character, name: 'Yudmit Longfeet', user: dono, campaign: campaign)

    logar_como master
    page.driver.browser.process_and_follow_redirects(:post, campaign_campaign_characters_path(campaign),
      { character_id: personagem.id })

    expect(page).to have_content 'Personagem já está em uma campanha.'
  end

  describe 'mestre remove personagem' do
    let!(:dono) { create(:user, name: 'Dono Um') }
    let!(:personagem) { create(:character, name: 'Belerion', user: dono, campaign: campaign) }
    let!(:vinculo) { personagem.campaign_characters.sole }

    scenario 'da lista da campanha' do
      logar_como master
      visit edit_campaign_path(campaign)
      click_button 'Remover'

      expect(page).to have_content 'Personagem removido da campanha.'
      expect(page).not_to have_content 'Belerion'
    end
  end
end
