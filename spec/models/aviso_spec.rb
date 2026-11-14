require 'rails_helper'

describe Aviso do
  describe 'Validacoes' do
    it { is_expected.not_to have_valid(:user).when(nil) }
    it { is_expected.not_to have_valid(:content).when(nil, '') }
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let!(:lido) { create(:aviso, user: user, read_at: 1.hour.ago) }
    let!(:nao_lido) { create(:aviso, user: user) }

    it 'separa lidos e nao_lidos' do
      expect(user.avisos.lidos).to contain_exactly(lido)
      expect(user.avisos.nao_lidos).to contain_exactly(nao_lido)
    end
  end
end
