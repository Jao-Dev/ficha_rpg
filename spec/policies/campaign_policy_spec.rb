require 'rails_helper'

describe CampaignPolicy do
  subject(:policy) { described_class.new(user, campaign) }

  describe 'qualquer usuário logado' do
    let(:user) { create(:user) }
    let(:campaign) { create(:campaign) }

    it { is_expected.to permit_actions(%i[show create]) }
  end

  describe 'mestre da campanha' do
    let(:user) { create(:user) }
    let(:campaign) { create(:campaign, master: user) }

    it { is_expected.to permit_actions(%i[update destroy]) }
  end

  describe 'outro usuário' do
    let(:user) { create(:user) }
    let(:campaign) { create(:campaign, master: create(:user)) }

    it { is_expected.to forbid_actions(%i[update destroy]) }
  end

  describe 'admin' do
    let(:user) { create(:user, role: :admin) }
    let(:campaign) { create(:campaign, master: create(:user)) }

    it { is_expected.to permit_actions(%i[show create update destroy]) }
  end
end
