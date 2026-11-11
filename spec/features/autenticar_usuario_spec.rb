require 'rails_helper'

feature 'autenticar usuário' do
  scenario 'tela de login renderizada por padrão' do
    visit new_user_session_path
    expect(page).to have_content 'Entrar'
    expect(page).to have_content 'Cadastrar-se'
  end

  scenario 'logar com sucesso' do
    logar_como_usuario
    expect(page).to have_content 'Logado com sucesso!'
  end

  scenario 'fazer logout' do
    logar_como_usuario
    expect(page).to have_button 'Log out'
    click_button 'Log out'
    expect(page).to have_content 'Entrar'
  end

  scenario 'fazer cadastro' do
    novo_usuario = User.new(name: 'teste', email: 'novo@gmail.com', password: 'teste123')

    visit new_user_session_path
    click_link 'Cadastrar-se'
    fill_in 'Nome', with: novo_usuario.name
    fill_in 'Email', with: novo_usuario.email
    fill_in 'Senha', with: novo_usuario.password
    fill_in 'Confirmar senha', with: novo_usuario.password
    click_button 'Cadastrar'

    expect(page).to have_content 'Logado com sucesso!'
  end

  scenario 'mensagem de erro ao errar ou deixar a senha em branco' do
    User.create!(name: 'teste', email: 'teste@gmail.com', password: 'teste123')

    visit new_user_session_path
    fill_in 'Email', with: 'teste@gmail.com'
    fill_in 'Senha', with: 'senha-errada'
    click_button 'Entrar'
    expect(page).to have_content 'Senha incorreta.'

    visit new_user_session_path
    fill_in 'Email', with: 'teste@gmail.com'
    click_button 'Entrar'
    expect(page).to have_content 'Senha incorreta.'
  end

  scenario 'mensagem de erro ao errar ou deixar o email em branco' do
    visit new_user_session_path
    fill_in 'Email', with: 'nao-existe@gmail.com'
    fill_in 'Senha', with: 'teste123'
    click_button 'Entrar'
    expect(page).to have_content 'Email não encontrado.'

    visit new_user_session_path
    fill_in 'Senha', with: 'teste123'
    click_button 'Entrar'
    expect(page).to have_content 'Email não encontrado.'
  end

  private

  def logar_como_usuario
    user = User.create!(name: 'teste', email: 'teste@gmail.com', password: 'teste123')

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_button 'Entrar'
  end
end
