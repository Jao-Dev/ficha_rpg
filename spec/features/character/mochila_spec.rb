require 'rails_helper'

feature 'mochila do personagem' do
  let(:dono) { create(:user, name: 'Dono Um') }
  let(:master) { create(:user, name: 'Mestre Um') }
  let(:campaign) { create(:campaign, master: master) }
  let(:personagem) { create(:character, name: 'Belerion', user: dono) }

  describe 'dono gerencia a mochila' do
    scenario 'adiciona item com quantidade' do
      logar_como dono
      visit user_character_path(dono, personagem)
      fill_in 'Item', with: 'Poção de cura'
      fill_in 'Quantidade', with: 3
      click_button 'Adicionar item'

      expect(page).to have_content 'Item adicionado à mochila.'
      expect(page).to have_content 'Poção de cura (3)'
    end

    scenario 'adiciona item com quantidade zero' do
      logar_como dono
      visit user_character_path(dono, personagem)
      fill_in 'Item', with: 'Flecha'
      fill_in 'Quantidade', with: 0
      click_button 'Adicionar item'

      expect(page).to have_content 'Item adicionado à mochila.'
      expect(page).to have_content 'Flecha (0)'
    end

    scenario 'não adiciona item sem nome' do
      logar_como dono
      visit user_character_path(dono, personagem)
      fill_in 'Quantidade', with: 2
      click_button 'Adicionar item'

      expect(page).to have_content 'Item inválido.'
      expect(page).to have_content 'Mochila vazia.'
    end

    scenario 'remove item da mochila' do
      personagem.update!(extras: { "mochila" => [ { "nome" => "Poção de vida", "quantidade" => 2 } ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      click_button 'Remover'

      expect(page).to have_content 'Item removido da mochila.'
      expect(page).not_to have_content 'Poção de vida'
    end

    scenario 'edita item da mochila' do
      personagem.update!(extras: { "mochila" => [ { "nome" => "Poção", "quantidade" => 3 } ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      find('summary', text: 'Editar').click
      fill_in "item_0", with: 'Poção de vida'
      fill_in "quantidade_0", with: 2
      click_button 'Salvar'

      expect(page).to have_content 'Item atualizado.'
      expect(page).to have_content 'Poção de vida (2)'
      expect(page).not_to have_content 'Poção (3)'
    end

    scenario 'não edita item sem nome' do
      personagem.update!(extras: { "mochila" => [ { "nome" => "Poção", "quantidade" => 3 } ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      find('summary', text: 'Editar').click
      fill_in "item_0", with: ''
      click_button 'Salvar'

      expect(page).to have_content 'Item inválido.'
      expect(page).to have_content 'Poção (3)'
    end
  end

  describe 'apenas o dono edita' do
    before do
      personagem.update!(campaign: campaign)
      personagem.update!(extras: { "mochila" => [ { "nome" => "Poção de vida", "quantidade" => 2 } ] })
    end

    scenario 'mestre da campanha vê a lista, mas não edita' do
      logar_como master
      visit user_character_path(dono, personagem)

      expect(page).to have_content 'Poção de vida (2)'
      expect(page).not_to have_button 'Adicionar item'
      expect(page).not_to have_button 'Remover'
      expect(page).not_to have_button 'Salvar'
    end
  end
end
