require 'rails_helper'

describe AvisoPolicy do
  subject(:policy) { described_class.new(user, aviso) }

  describe 'qualquer usuário logado' do
    let(:user) { create(:user) }
    let(:aviso) { Aviso.new }

    it { is_expected.to permit_action(:index) }
  end

  describe 'dono do aviso' do
    let(:user) { create(:user) }
    let(:aviso) { create(:aviso, user: user) }

    it { is_expected.to permit_action(:show) }
  end

  describe 'outro usuário' do
    let(:user) { create(:user) }
    let(:aviso) { create(:aviso) }

    it { is_expected.to forbid_action(:show) }
  end
end
