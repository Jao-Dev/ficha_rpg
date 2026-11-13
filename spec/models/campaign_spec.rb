require 'rails_helper'

describe Campaign do
  describe 'Validacoes' do
      it { is_expected.not_to have_valid(:master).when(nil) }
      it { is_expected.not_to have_valid(:ativo).when(nil, '') }
  end

  describe 'exclusão' do
    it 'com personagens é bloqueada' do
      campaign = create(:campaign)
      create(:character, campaign: campaign)

      expect(campaign.destroy).to be(false)
      expect(campaign.errors[:base]).to be_present
    end
  end
end
