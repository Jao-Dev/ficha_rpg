require 'rails_helper'

feature 'avisos' do
  let(:dono) { create(:user, name: 'Dono Um') }
  let(:master) { create(:user, name: 'Mestre Um') }
  let(:campaign) { create(:campaign, master: master) }
  let!(:personagem) { create(:character, name: 'Belerion', user: dono) }

  describe 'index e show' do
    scenario 'mostra título com o tipo e leva à tela do aviso' do
      create(:aviso, :inserido, user: dono)

      logar_como dono
      visit avisos_path
      expect(page).to have_text 'Personagem inserido'
      expect(page).to have_text 'Seu personagem Belerion foi inserido na campanha de Mestre Um.'

      click_link 'Personagem inserido'
      expect(page).to have_text 'Seu personagem Belerion foi inserido na campanha de Mestre Um.'
    end

    scenario 'abrir o aviso marca só ele como lido' do
      create(:aviso, :inserido, user: dono)
      create(:aviso, :confirmado, user: dono)

      logar_como dono
      expect(page).to have_text 'Avisos (2)'
      visit avisos_path
      click_link 'Personagem inserido'

      expect(page).to have_text 'Avisos (1)'
      visit avisos_path
      click_link 'Personagem confirmado'

      expect(page).not_to have_text 'Avisos (1)'
      visit avisos_path
      click_link 'Personagem inserido'

      expect(page).to have_text 'Seu personagem Belerion foi inserido na campanha de Mestre Um.'
    end
  end

  describe 'personagem inserido em campanha' do
    scenario 'dono recebe aviso quando mestre insere o personagem' do
      logar_como master
      visit edit_campaign_path(campaign)
      fill_in 'Personagem', with: 'Belerion'
      click_button 'Buscar'
      click_button 'Adicionar'

      logar_como dono
      visit avisos_path

      expect(page).to have_text 'Personagem inserido'
      expect(page).to have_text 'Seu personagem Belerion foi inserido na campanha de Mestre Um.'
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

      expect(page).to have_text 'Personagem confirmado'
      expect(page).to have_text 'Dono Um confirmou o personagem Belerion na sua campanha.'
    end

    scenario 'mestre recebe aviso quando dono recusa' do
      logar_como dono
      visit campaigns_path
      click_button 'Recusar'

      logar_como master
      visit avisos_path

      expect(page).to have_text 'Personagem recusado'
      expect(page).to have_text 'Dono Um recusou o personagem Belerion na sua campanha.'
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

      expect(page).to have_text 'Personagem removido'
      expect(page).to have_text 'Seu personagem Belerion foi removido da campanha de Mestre Um.'
    end
  end

  scenario 'usuário não vê avisos de outro usuário' do
    outro = create(:user)
    create(:aviso, user: outro, content: 'Aviso secreto de outro usuário.')

    logar_como dono
    visit avisos_path

    expect(page).not_to have_text 'Aviso secreto de outro usuário.'
  end

  scenario 'usuário não abre aviso de outro usuário' do
    aviso_de_outro = create(:aviso, user: create(:user), content: 'Aviso secreto de outro usuário.')

    logar_como dono
    visit aviso_path(aviso_de_outro)

    expect(page).to have_text 'Você não tem acesso a esta página.'
  end
end
