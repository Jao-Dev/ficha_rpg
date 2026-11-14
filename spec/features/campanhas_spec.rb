require 'rails_helper'

feature 'minhas campanhas' do
  describe 'listar campanhas' do
    let(:user) { create(:user) }
    let!(:minha) { create(:campaign, master: user) }
    let!(:participo) { create(:campaign) }
    let!(:vinculo) do
      create(:campaign_character, :ativo, campaign: participo, character: create(:character, user: user))
    end
    let!(:outra) { create(:campaign) }

    scenario 'mostra campanhas onde sou mestre ou participo, e nada além' do
      logar_como user
      visit campaigns_path

      expect(page).to have_content minha.master.name
      expect(page).to have_content participo.master.name
      expect(page).not_to have_content outra.master.name
    end

    scenario 'leva à ficha da campanha' do
      logar_como user
      visit campaigns_path
      click_link minha.master.name

      expect(page).to have_content minha.created_at.strftime('%d/%m/%Y')
    end
  end

  describe 'personagens aguardando confirmação' do
    let(:user) { create(:user) }
    let(:campaign) { create(:campaign) }
    let!(:personagem) { create(:character, name: 'Belerion', user: user) }
    let!(:vinculo) do
      create(:campaign_character, campaign: campaign, character: personagem).tap do
        personagem.update!(campaign: campaign)
      end
    end

    scenario 'confirma o personagem na campanha' do
      logar_como user
      visit campaigns_path
      click_button 'Confirmar'

      expect(page).to have_content 'Personagem confirmado na campanha.'
      expect(page).to have_content campaign.master.name
    end

    scenario 'recusa a participação' do
      logar_como user
      visit campaigns_path
      click_button 'Recusar'

      expect(page).to have_content 'Participação recusada.'
      expect(page).not_to have_content campaign.master.name
    end
  end
end
