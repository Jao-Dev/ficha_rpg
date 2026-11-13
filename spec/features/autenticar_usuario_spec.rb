require 'rails_helper'

feature 'autenticar usuário' do
  let!(:user) { create(:user, name: 'teste', email: 'teste@gmail.com', password: 'teste123') }

  describe 'sessão' do
    scenario 'tela de login renderizada por padrão' do
      visit new_user_session_path
      expect(page).to have_content 'Entrar'
      expect(page).to have_content 'Cadastrar-se'
    end

    scenario 'logar com sucesso' do
      logar_como user
      expect(page).to have_content 'Login efetuado com sucesso.'
    end

    scenario 'fazer logout' do
      logar_como user
      expect(page).to have_button 'Log out'
      click_button 'Log out'
      expect(page).to have_content 'Entrar'
    end

    scenario 'com senha errada ou em branco mostra erro' do
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Senha', with: 'senha-errada'
      click_button 'Entrar'
      expect(page).to have_content 'Senha incorreta.'

      visit new_user_session_path
      fill_in 'Email', with: user.email
      click_button 'Entrar'
      expect(page).to have_content 'Senha incorreta.'
    end

    scenario 'com email em branco ou inexistente mostra erro' do
      visit new_user_session_path
      fill_in 'Email', with: 'nao-existe@gmail.com'
      fill_in 'Senha', with: 'teste123'
      click_button 'Entrar'
      expect(page).to have_content 'Email não encontrado.'

      visit new_user_session_path
      fill_in 'Email', with: ''
      fill_in 'Senha', with: 'teste123'
      click_button 'Entrar'
      expect(page).to have_content 'Email não encontrado.'
    end
  end

  describe 'cadastro' do
    let(:novo_usuario) { build(:user, name: 'teste', email: 'novo@gmail.com', password: 'teste123') }

    scenario 'com sucesso' do
      visit new_user_session_path
      click_link 'Cadastrar-se'
      fill_in 'Nome', with: novo_usuario.name
      fill_in 'Email', with: novo_usuario.email
      fill_in 'Senha', with: novo_usuario.password
      fill_in 'Confirmar senha', with: novo_usuario.password
      click_button 'Cadastrar'

      expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    end
  end
end
