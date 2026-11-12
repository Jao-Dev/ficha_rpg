require 'rails_helper'

feature 'gerenciar campanhas' do
  scenario 'ver a campanha' do
    user = create(:user)
    campaign = create(:campaign, master: 'Mestre boladão')
    character = create(:character, name: 'Yudmit Longfeet', user: user, campaign: campaign)

    logar_como user
    visit campaign_path(campaign)

    expect(page).to have_content 'Mestre boladão'
    expect(page).to have_content 'Ativa'
    expect(page).to have_content campaign.created_at.strftime('%d/%m/%Y')
    expect(page).to have_content character.name
  end

  scenario 'criar campanha' do
    user = create(:user)

    logar_como user
    click_link 'Nova campanha'
    fill_in 'Mestre', with: 'Mestre boladão'
    click_button 'Criar campanha'

    expect(page).to have_content 'Campanha criada com sucesso.'
    expect(page).to have_content 'Mestre boladão'
  end

  scenario 'criar campanha com mestre em branco mostra erro' do
    user = create(:user)

    logar_como user
    click_link 'Nova campanha'
    click_button 'Criar campanha'

    expect(page).to have_content 'Não foi possível salvar a campanha.'
    expect(page).to have_content 'Mestre não pode ficar em branco'
  end
end
