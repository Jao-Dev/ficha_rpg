require 'rails_helper'

feature 'ficha do personagem' do
  let(:dono) { create(:user, name: 'Dono Um') }
  let(:master) { create(:user, name: 'Mestre Um') }
  let(:campaign) { create(:campaign, master: master) }
  let(:personagem) { create(:character, name: 'Belerion', user: dono) }

  describe 'anotações e história' do
    scenario 'dono registra na ficha e vê ao salvar' do
      logar_como dono
      visit edit_user_character_path(dono, personagem)
      fill_in 'Anotações', with: 'Colecionou três crânios de dragão.'
      fill_in 'História', with: 'Exilado das montanhas por heresia.'
      click_button 'Atualizar personagem'

      expect(page).to have_content 'Colecionou três crânios de dragão.'
      expect(page).to have_content 'Exilado das montanhas por heresia.'
    end

    scenario 'mestre da campanha vê a história, mas não as anotações' do
      personagem.update!(campaign: campaign,
        anotacoes: 'Colecionou três crânios de dragão.', historia: 'Exilado das montanhas por heresia.')

      logar_como master
      visit user_character_path(dono, personagem)

      expect(page).to have_content 'Exilado das montanhas por heresia.'
      expect(page).not_to have_content 'Colecionou três crânios de dragão.'
    end
  end
end
