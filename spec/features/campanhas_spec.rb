require 'rails_helper'

feature 'minhas campanhas' do
  describe 'listar campanhas' do
    let(:user) { create(:user) }
    let!(:minha) { create(:campaign, master: user, nome: 'A Sombra de Nargol') }
    let!(:participo) { create(:campaign, nome: 'A Torre do Feiticeiro') }
    let!(:vinculo) do
      create(:campaign_character, :ativo, campaign: participo, character: create(:character, user: user))
    end
    let!(:outra) { create(:campaign, nome: 'As Ruínas de Ilthan') }
    let!(:inativa) { create(:campaign, master: user, nome: 'A Cripta Sombria', ativo: false) }

    scenario 'mostra campanhas do usuário e as outras' do
      logar_como user
      visit campaigns_path

      expect(page).to have_text 'Campanhas do usuário'
      expect(page).to have_text 'Outras campanhas'
      expect(page).to have_text 'A Sombra de Nargol'
      expect(page).to have_text 'A Torre do Feiticeiro'
      expect(page).to have_text 'As Ruínas de Ilthan'
    end

    scenario 'cada campanha mostra mestre e status' do
      logar_como user
      visit campaigns_path

      expect(page).to have_text user.name
      expect(page).to have_text 'Inativa'
    end

    scenario 'leva à ficha da campanha' do
      logar_como user
      visit campaigns_path
      click_link 'A Sombra de Nargol'

      expect(page).to have_text minha.created_at.strftime('%d/%m/%Y')
    end

    describe 'pesquisa' do
      scenario 'por nome da campanha' do
        logar_como user
        visit campaigns_path
        fill_in 'Campanha ou mestre', with: 'Nargol'
        click_button 'Buscar'

        expect(page).to have_text 'A Sombra de Nargol'
        expect(page).not_to have_text 'A Torre do Feiticeiro'
      end

      scenario 'por nome do mestre' do
        logar_como user
        visit campaigns_path
        fill_in 'Campanha ou mestre', with: participo.master.name
        click_button 'Buscar'

        expect(page).to have_text 'A Torre do Feiticeiro'
        expect(page).not_to have_text 'A Sombra de Nargol'
      end

      scenario 'por status' do
        logar_como user
        visit campaigns_path
        select 'Inativa', from: 'Status'
        click_button 'Buscar'

        expect(page).to have_text 'A Cripta Sombria'
        expect(page).not_to have_text 'A Sombra de Nargol'

        visit campaigns_path
        select 'Ativa', from: 'Status'
        click_button 'Buscar'

        expect(page).to have_text 'A Sombra de Nargol'
        expect(page).not_to have_text 'A Cripta Sombria'
      end
    end
  end

  describe 'estado vazio' do
    scenario 'sem campanhas no sistema' do
      logar_como create(:user)
      visit campaigns_path

      expect(page).to have_text 'Você não participa de nenhuma campanha ainda.'
      expect(page).to have_text 'Nenhuma outra campanha no sistema.'
    end
  end

  describe 'botão nova campanha' do
    let(:user) { create(:user) }

    scenario 'sai da navbar e fica na index' do
      logar_como user
      visit users_path

      expect(page).not_to have_link 'Nova campanha'

      visit campaigns_path
      click_link 'Nova campanha'
      expect(page).to have_field 'Nome', with: ''
    end
  end

  describe 'personagens aguardando confirmação' do
    let(:user) { create(:user) }
    let(:campaign) { create(:campaign) }
    let!(:personagem) { create(:character, name: 'Belerion', user: user) }
    let!(:vinculo) do
      create(:campaign_character, campaign: campaign, character: personagem).tap do
        personagem.update!(campaign: campaign)
      end
    end

    scenario 'confirma o personagem na campanha' do
      logar_como user
      visit campaigns_path
      click_button 'Confirmar'

      expect(page).to have_text 'Personagem confirmado na campanha.'
    end

    scenario 'recusa a participação' do
      logar_como user
      visit campaigns_path
      click_button 'Recusar'

      expect(page).to have_text 'Participação recusada.'
    end
  end
end
