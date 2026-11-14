require 'rails_helper'

feature 'avisos' do
  let(:dono) { create(:user, name: 'Dono Um') }
  let(:master) { create(:user, name: 'Mestre Um') }
  let(:campaign) { create(:campaign, master: master) }
  let!(:personagem) { create(:character, name: 'Belerion', user: dono) }

  describe 'personagem inserido em campanha' do
    scenario 'dono recebe aviso quando mestre insere o personagem' do
      logar_como master
      visit edit_campaign_path(campaign)
      fill_in 'Personagem', with: 'Belerion'
      click_button 'Buscar'
      click_button 'Adicionar'

      logar_como dono
      expect(page).to have_content 'Avisos (1)'
      click_link 'Avisos (1)'

      expect(page).to have_content 'Seu personagem Belerion foi inserido na campanha de Mestre Um.'
    end

    scenario 'abrir a tela marca os avisos como lidos' do
      create(:aviso, user: dono,
        content: 'Seu personagem Belerion foi inserido na campanha de Mestre Um.')

      logar_como dono
      expect(page).to have_content 'Avisos (1)'
      click_link 'Avisos (1)'

      expect(page).to have_content 'Seu personagem Belerion foi inserido na campanha de Mestre Um.'
      expect(page).not_to have_content 'Avisos (1)'
    end
  end

  describe 'dono responde' do
    let!(:vinculo) do
      create(:campaign_character, campaign: campaign, character: personagem).tap do
        personagem.update!(campaign: campaign)
      end
    end

    scenario 'mestre recebe aviso quando dono confirma' do
      logar_como dono
      visit campaigns_path
      click_button 'Confirmar'

      logar_como master
      visit avisos_path

      expect(page).to have_content 'Dono Um confirmou o personagem Belerion na sua campanha.'
    end

    scenario 'mestre recebe aviso quando dono recusa' do
      logar_como dono
      visit campaigns_path
      click_button 'Recusar'

      logar_como master
      visit avisos_path

      expect(page).to have_content 'Dono Um recusou o personagem Belerion na sua campanha.'
    end
  end

  describe 'mestre remove personagem' do
    let!(:vinculo) do
      create(:campaign_character, :ativo, campaign: campaign, character: personagem).tap do
        personagem.update!(campaign: campaign)
      end
    end

    scenario 'dono recebe aviso quando mestre remove' do
      logar_como master
      visit edit_campaign_path(campaign)
      click_button 'Remover'

      logar_como dono
      visit avisos_path

      expect(page).to have_content 'Seu personagem Belerion foi removido da campanha de Mestre Um.'
    end
  end

  scenario 'usuário não vê avisos de outro usuário' do
    outro = create(:user)
    create(:aviso, user: outro, content: 'Aviso secreto de outro usuário.')

    logar_como dono
    visit avisos_path

    expect(page).not_to have_content 'Aviso secreto de outro usuário.'
  end
end
