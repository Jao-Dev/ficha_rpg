require 'rails_helper'

feature 'listar personagens' do
  scenario 'exibe os personagens do usuário logado' do
    usuario = create(:user, password: 'teste123')
    personagem = create(:character, user: usuario, name: 'Arador')
    outro_personagem = create(:character, name: 'Gorim')

    logar_como(usuario)
    visit root_path

    expect(page).to have_content personagem.name
    expect(page).to have_no_content outro_personagem.name
  end

  scenario 'pede login quando não autenticado' do
    visit root_path
    expect(page).to have_content 'Entrar'
  end

  private

  def logar_como(usuario)
    visit new_user_session_path
    fill_in 'Email', with: usuario.email
    fill_in 'Senha', with: usuario.password
    click_button 'Entrar'
  end
end
