require 'rails_helper'

feature 'armas do personagem' do
  let(:dono) { create(:user, name: 'Dono Um') }
  let(:master) { create(:user, name: 'Mestre Um') }
  let(:campaign) { create(:campaign, master: master) }
  let(:personagem) { create(:character, name: 'Belerion', user: dono) }

  describe 'dono gerencia as armas' do
    scenario 'adiciona arma com dano' do
      logar_como dono
      visit user_character_path(dono, personagem)
      fill_in 'Arma', with: 'Machado de guerra'
      fill_in 'Dano', with: '2d6 de dano'
      click_button 'Adicionar arma'

      expect(page).to have_content 'Arma adicionada.'
      expect(page).to have_content 'Machado de guerra (2d6 de dano)'
    end

    scenario 'não adiciona arma sem dano' do
      logar_como dono
      visit user_character_path(dono, personagem)
      fill_in 'Arma', with: 'Machado de guerra'
      click_button 'Adicionar arma'

      expect(page).to have_content 'Arma inválida.'
      expect(page).to have_content 'Nenhuma arma.'
    end

    scenario 'remove arma' do
      personagem.update!(extras: { "armas" => [ { "nome" => "Machado de guerra", "dano" => "2d6 de dano" } ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      click_button 'Remover'

      expect(page).to have_content 'Arma removida.'
      expect(page).not_to have_content 'Machado de guerra'
    end

    scenario 'edita arma' do
      personagem.update!(extras: { "armas" => [ { "nome" => "Machado", "dano" => "2d6 de dano" } ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      find('summary', text: 'Editar').click
      fill_in "arma_0", with: 'Espada longa'
      fill_in "dano_0", with: '1d8 de dano'
      click_button 'Salvar'

      expect(page).to have_content 'Arma atualizada.'
      expect(page).to have_content 'Espada longa (1d8 de dano)'
      expect(page).not_to have_content 'Machado'
    end

    scenario 'não edita arma sem dano' do
      personagem.update!(extras: { "armas" => [ { "nome" => "Machado", "dano" => "2d6 de dano" } ] })

      logar_como dono
      visit user_character_path(dono, personagem)
      find('summary', text: 'Editar').click
      fill_in "dano_0", with: ''
      click_button 'Salvar'

      expect(page).to have_content 'Arma inválida.'
      expect(page).to have_content 'Machado (2d6 de dano)'
    end
  end

  describe 'apenas o dono edita' do
    before do
      personagem.update!(campaign: campaign)
      personagem.update!(extras: { "armas" => [ { "nome" => "Machado de guerra", "dano" => "2d6 de dano" } ] })
    end

    scenario 'mestre da campanha vê as armas, mas não edita' do
      logar_como master
      visit user_character_path(dono, personagem)

      expect(page).to have_content 'Machado de guerra (2d6 de dano)'
      expect(page).not_to have_button 'Adicionar arma'
      expect(page).not_to have_button 'Remover'
      expect(page).not_to have_button 'Salvar'
    end
  end
end
