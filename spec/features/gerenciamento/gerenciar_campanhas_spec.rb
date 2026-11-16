require 'rails_helper'

feature 'gerenciar campanhas' do
  let(:user) { create(:user) }

  describe 'ver a campanha' do
    let(:master) { create(:user, name: 'Mestre boladão') }
    let(:campaign) { create(:campaign, master: master, nome: 'A Sombra de Nargol') }
    let!(:character) { create(:character, name: 'Yudmit Longfeet', user: user, campaign: campaign) }
    let!(:vinculo) { character.campaign_characters.sole }

    scenario 'exibe nome, mestre, status, data e personagens' do
      logar_como user
      visit campaign_path(campaign)

      expect(page).to have_content 'A Sombra de Nargol'
      expect(page).to have_content 'Mestre boladão'
      expect(page).to have_content 'Ativa'
      expect(page).to have_content campaign.created_at.strftime('%d/%m/%Y')
      expect(page).to have_content character.name
    end

    scenario 'personagens exibem foto com o nome' do
      character.avatar.attach(
        io: Rails.root.join('spec/resources/dummies/dummy.png').open,
        filename: 'dummy.png'
      )

      logar_como user
      visit campaign_path(campaign)

      expect(page).to have_css 'img'
      expect(page).to have_content 'Yudmit Longfeet'
    end

    scenario 'exibe o resumo escrito pelo mestre' do
      campaign.update!(resumo: 'Uma jornada pelas montanhas de Nargol.')

      logar_como user
      visit campaign_path(campaign)

      expect(page).to have_content 'Uma jornada pelas montanhas de Nargol.'
    end

    scenario 'jogador não vê botões de edição' do
      logar_como user
      visit campaign_path(campaign)

      expect(page).not_to have_link 'Editar'
      expect(page).not_to have_link 'Excluir'
    end
  end

  describe 'criar campanha' do
    scenario 'via formulário com nome e o criador se torna o mestre' do
      logar_como user
      click_link 'Nova campanha'
      fill_in 'Nome', with: 'A Torre do Feiticeiro'
      click_button 'Criar campanha'

      expect(page).to have_content 'Campanha criada com sucesso.'
      expect(page).to have_content 'A Torre do Feiticeiro'
      expect(page).to have_content user.name
    end

    scenario 'sem nome mostra erro' do
      logar_como user
      click_link 'Nova campanha'
      click_button 'Criar campanha'

      expect(page).to have_content 'Não foi possível salvar a campanha.'
    end
  end

  describe 'editar campanha' do
    let(:master) { create(:user) }
    let(:campaign) { create(:campaign, master: master, nome: 'A Sombra de Nargol') }

    scenario 'com sucesso' do
      logar_como master
      visit campaign_path(campaign)
      click_link 'Editar'
      uncheck 'Ativa'
      click_button 'Atualizar campanha'

      expect(page).to have_content 'Campanha atualizada com sucesso.'
      expect(page).to have_content 'Inativa'
    end

    scenario 'mestre renomeia e escreve o resumo' do
      logar_como master
      visit campaign_path(campaign)
      click_link 'Editar'
      fill_in 'Nome', with: 'A Torre do Feiticeiro'
      fill_in 'Resumo', with: 'Uma jornada pelas montanhas de Nargol.'
      click_button 'Atualizar campanha'

      expect(page).to have_content 'Campanha atualizada com sucesso.'
      expect(page).to have_content 'A Torre do Feiticeiro'
      expect(page).to have_content 'Uma jornada pelas montanhas de Nargol.'
    end
  end

  describe 'excluir campanha' do
    let(:master) { create(:user) }
    let(:campaign) { create(:campaign, master: master) }

    scenario 'com sucesso' do
      logar_como master
      visit campaign_path(campaign)
      click_button 'Excluir'

      expect(page).to have_content 'Campanha excluída com sucesso.'
      within '.page-body' do
        expect(page).not_to have_content campaign.master.name
      end
    end

    scenario 'com personagens mostra erro' do
      character = create(:character, user: create(:user), campaign: campaign)

      logar_como master
      visit campaign_path(campaign)
      click_button 'Excluir'

      expect(page).to have_content 'Não foi possível excluir a campanha.'
      expect(page).to have_content character.name
    end
  end
end
