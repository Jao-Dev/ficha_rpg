require 'rails_helper'

feature 'página inicial' do
  scenario 'visitante é redirecionado para o login' do
    visit root_path
    expect(page).to have_content 'Entrar'
  end

  scenario 'usuário logado vê a lista de seus personagens' do
    user = User.create!(name: 'teste', email: 'teste@gmail.com', password: 'teste123')
    campanha = create(:campaign)
    personagem = create(:character, user: user, campaign: campanha)

    logar_como user

    expect(page).to have_content personagem.name
  end

  scenario 'usuário logado não vê personagens de outros usuários' do
    campanha = create(:campaign)
    personagem_de_outro = create(:character, campaign: campanha)
    user = User.create!(name: 'teste', email: 'teste@gmail.com', password: 'teste123')

    logar_como user

    expect(page).not_to have_content personagem_de_outro.name
  end
end
