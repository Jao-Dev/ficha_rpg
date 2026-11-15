require 'rails_helper'

feature 'efeitos do personagem' do
  let(:dono) { create(:user, name: 'Dono Um') }
  let(:master) { create(:user, name: 'Mestre Um') }
  let(:campaign) { create(:campaign, master: master) }
  let(:personagem) { create(:character, name: 'Belerion', user: dono) }

  describe 'dono gerencia os efeitos' do
    scenario 'adiciona efeito' do
      logar_como dono
      visit user_character_path(dono, personagem)
      fill_in 'Efeito', with: '+4d8 de armadura por 2 rodadas'
      click_button 'Adicionar efeito'

      expect(page).to have_content 'Efeito adicionado.'
      expect(page).to have_content '+4d8 de armadura por 2 rodadas'
    end

    scenario 'não adiciona efeito vazio' do
      logar_como dono
      visit user_character_path(dono, personagem)
      click_button 'Adicionar efeito'

      expect(page).to have_content 'Efeito inválido.'
      expect(page).to have_content 'Nenhum efeito.'
    end

    scenario 'remove efeito' do
      personagem.update!(extras: { "efeitos" => [ "+4d8 de armadura por 2 rodadas" ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      click_button 'Remover'

      expect(page).to have_content 'Efeito removido.'
      expect(page).not_to have_content '+4d8 de armadura por 2 rodadas'
    end

    scenario 'edita efeito' do
      personagem.update!(extras: { "efeitos" => [ "+4d8 de armadura por 2 rodadas" ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      find('summary', text: 'Editar').click
      fill_in "efeito_0", with: '+2d6 de dano por 1 rodada'
      click_button 'Salvar'

      expect(page).to have_content 'Efeito atualizado.'
      expect(page).to have_content '+2d6 de dano por 1 rodada'
      expect(page).not_to have_content '+4d8 de armadura por 2 rodadas'
    end

    scenario 'não edita efeito vazio' do
      personagem.update!(extras: { "efeitos" => [ "+4d8 de armadura por 2 rodadas" ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      find('summary', text: 'Editar').click
      fill_in "efeito_0", with: ''
      click_button 'Salvar'

      expect(page).to have_content 'Efeito inválido.'
      expect(page).to have_content '+4d8 de armadura por 2 rodadas'
    end
  end

  describe 'apenas o dono edita' do
    before do
      personagem.update!(campaign: campaign)
      personagem.update!(extras: { "efeitos" => [ "+4d8 de armadura por 2 rodadas" ] })
    end

    scenario 'mestre da campanha vê os efeitos, mas não edita' do
      logar_como master
      visit user_character_path(dono, personagem)

      expect(page).to have_content '+4d8 de armadura por 2 rodadas'
      expect(page).not_to have_button 'Adicionar efeito'
      expect(page).not_to have_button 'Remover'
      expect(page).not_to have_button 'Salvar'
    end
  end
end
