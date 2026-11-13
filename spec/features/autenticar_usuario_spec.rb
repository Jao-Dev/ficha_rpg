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

    scenario 'cadastra e envia e-mail de confirmação' do
      visit new_user_session_path
      click_link 'Cadastrar-se'
      fill_in 'Nome', with: novo_usuario.name
      fill_in 'Email', with: novo_usuario.email
      fill_in 'Senha', with: novo_usuario.password
      fill_in 'Confirmar senha', with: novo_usuario.password
      click_button 'Cadastrar'

      expect(page).to have_content 'Uma mensagem com um link de confirmação foi enviada para o seu e-mail. Por favor, acesse o link para ativar sua conta.'
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include novo_usuario.email
      expect(email.body.to_s).to include 'confirmation_token='
    end
  end

  describe 'confirmação' do
    let!(:usuario_novo) { create(:user, :sem_confirmacao, name: 'teste', email: 'novo@gmail.com') }

    scenario 'não loga sem confirmar o e-mail' do
      logar_como usuario_novo
      expect(page).to have_content 'Antes de continuar, confirme a sua conta.'
    end

    scenario 'confirmando o e-mail entra como autenticado' do
      token = token_do_ultimo_email(:confirmation_token)

      visit user_confirmation_path(confirmation_token: token)

      expect(page).to have_content 'A sua conta foi confirmada com sucesso.'
    end
  end

  describe 'recuperação de senha' do
    let(:usuario_recuperando) { create(:user, email: 'recuperar@gmail.com', password: 'senha-antiga') }

    scenario 'envia instruções e redefine a senha' do
      visit new_user_session_path
      click_link 'Esqueceu sua senha?'
      fill_in 'Email', with: usuario_recuperando.email
      click_button 'Enviar instruções de recuperação de senha'

      expect(page).to have_content 'Dentro de minutos, você receberá um e-mail com as instruções de redefinição da sua senha.'

      token = token_do_ultimo_email(:reset_password_token)

      visit edit_user_password_path(reset_password_token: token)
      fill_in 'Nova senha', with: 'nova-senha-123'
      fill_in 'Confirmar nova senha', with: 'nova-senha-123'
      click_button 'Mudar minha senha'

      expect(page).to have_content 'A sua senha foi alterada com sucesso. Você está autenticado.'
    end

    scenario 'com email inexistente mostra erro' do
      visit new_user_session_path
      click_link 'Esqueceu sua senha?'
      fill_in 'Email', with: 'nao-existe@gmail.com'
      click_button 'Enviar instruções de recuperação de senha'

      expect(page).to have_content 'não encontrado'
    end
  end

  private

  def token_do_ultimo_email(parametro)
    ActionMailer::Base.deliveries.last.body.to_s[/#{parametro}=([^"&]+)/, 1]
  end
end
