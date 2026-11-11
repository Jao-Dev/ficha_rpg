require 'rails_helper'

feature 'autenticar usuário' do
  before :each do
    User.create!(name: 'teste', email: 'teste@gmail.com', password: 'teste123')
  end

  scenario 'tela de login renderizada por padrão' do
    visit new_user_session_path
    expect(page).to have_button 'Log in'
  end

  scenario 'logar com sucesso' do
    visit new_user_session_path
    fill_in 'Email', with: 'teste@gmail.com'
    fill_in 'Password', with: 'teste123'
    click_button 'Log in'
    expect(page).to have_content 'Logado com sucesso!'
  end
end
