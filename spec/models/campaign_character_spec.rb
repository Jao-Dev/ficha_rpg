require 'rails_helper'

describe CampaignCharacter do
  describe 'Validacoes' do
    it { is_expected.not_to have_valid(:character).when(nil) }
    it { is_expected.not_to have_valid(:campaign).when(nil) }
  end

  describe 'status' do
    it 'vínculo começa pendente' do
      vinculo = create(:campaign_character)

      expect(vinculo).to be_pendente
    end

    it 'vínculo confirmado fica ativo' do
      vinculo = create(:campaign_character, :ativo)

      expect(vinculo).to be_ativo
    end
  end
end
