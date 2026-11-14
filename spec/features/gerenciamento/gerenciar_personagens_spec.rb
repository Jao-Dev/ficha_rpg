require 'rails_helper'

feature 'gerenciar personagens' do
  let(:user) { create(:user) }
  let!(:campaign) { create(:campaign) }

  describe 'ver a ficha do personagem' do
    let!(:character) do
      create(:character, user: user, campaign: campaign, race: 'Anão').tap do |personagem|
        personagem.avatar.attach(
          io: Rails.root.join('spec/resources/dummies/dummy.png').open,
          filename: 'dummy.png'
        )
      end
    end

    scenario 'exibe nome, raça, mestre da campanha e a foto' do
      logar_como user
      visit user_character_path(user, character)

      expect(page).to have_content character.name
      expect(page).to have_content 'Anão'
      expect(page).to have_content campaign.master
      expect(page).to have_css("img[src*='dummy.png']")
    end

    scenario 'sem campanha não exibe mestre' do
      personagem = create(:character, user: user, race: 'Anão')

      logar_como user
      visit user_character_path(user, personagem)

      expect(page).to have_content personagem.name
      expect(page).to have_content 'Anão'
    end
  end

  describe 'criar personagem' do
    scenario 'com foto' do
      logar_como user
      click_link 'Novo personagem'
      fill_in 'Nome', with: 'Yudmit Longfeet'
      fill_in 'Raça', with: 'Anão'
      select campaign.master.name, from: 'Campanha'
      attach_file 'Foto', Rails.root.join('spec/resources/dummies/dummy.png')
      click_button 'Criar personagem'

      expect(page).to have_content 'Yudmit Longfeet'
      expect(page).to have_content 'Anão'
      expect(page).to have_css("img[src*='dummy.png']")
    end

    scenario 'com campos obrigatórios em branco mostra erros' do
      logar_como user
      click_link 'Novo personagem'
      click_button 'Criar personagem'

      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Raça não pode ficar em branco'
    end

    scenario 'com foto inválida mostra erro' do
      logar_como user
      click_link 'Novo personagem'
      fill_in 'Nome', with: 'Yudmit Longfeet'
      fill_in 'Raça', with: 'Anão'
      attach_file 'Foto', Rails.root.join('spec/resources/dummies/dummy.pdf')
      click_button 'Criar personagem'

      expect(page).to have_content 'deve ser uma imagem PNG ou JPEG'
    end
  end

  describe 'editar personagem' do
    let!(:character) { create(:character, user: user, race: 'Anão') }

    scenario 'com sucesso' do
      logar_como user
      visit user_character_path(user, character)
      click_link 'Editar'
      fill_in 'Raça', with: 'Elfo'
      click_button 'Atualizar personagem'

      expect(page).to have_content 'Personagem atualizado com sucesso.'
      expect(page).to have_content 'Elfo'
      expect(page).not_to have_content 'Anão'
    end

    scenario 'com dados inválidos mostra erro' do
      logar_como user
      visit user_character_path(user, character)
      click_link 'Editar'
      fill_in 'Nome', with: ''
      click_button 'Atualizar personagem'

      expect(page).to have_content 'Não foi possível salvar o personagem.'
      expect(page).to have_content 'Nome não pode ficar em branco'
    end
  end

  describe 'excluir personagem' do
    let!(:character) { create(:character, user: user) }

    scenario 'com sucesso' do
      logar_como user
      visit user_character_path(user, character)
      click_button 'Excluir'

      expect(page).not_to have_content character.name
      expect(page).to have_content 'Personagem excluído com sucesso.'
    end
  end
end
