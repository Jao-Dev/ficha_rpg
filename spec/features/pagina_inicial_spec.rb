require 'rails_helper'

feature 'página inicial' do
  let(:user) { create(:user, name: 'teste', email: 'teste@gmail.com', password: 'teste123') }
  let!(:personagem) { create(:character, user: user, name: 'Arador') }
  let!(:outro_personagem) { create(:character, name: 'Gorim') }

  scenario 'visitante é redirecionado para o login' do
    visit root_path
    expect(page).to have_content 'Entrar'
  end

  scenario 'usuário logado vê a lista de seus personagens' do
    logar_como user
    expect(page).to have_content personagem.name
  end

  scenario 'usuário logado não vê personagens de outros usuários' do
    logar_como user
    expect(page).not_to have_content outro_personagem.name
  end
end
