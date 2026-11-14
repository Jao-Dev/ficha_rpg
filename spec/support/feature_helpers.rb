module FeatureHelpers
  def logar_como(user)
    click_button 'Log out' if page.has_button?('Log out')
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_button 'Entrar'
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
