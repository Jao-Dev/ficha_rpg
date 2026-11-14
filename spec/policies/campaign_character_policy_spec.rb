require 'rails_helper'

describe CampaignCharacterPolicy do
  subject(:policy) { described_class.new(user, vinculo) }

  let(:user) { create(:user) }
  let(:vinculo) { create(:campaign_character) }

  describe 'mestre da campanha' do
    let(:master) { create(:user) }
    let(:vinculo) { create(:campaign_character, campaign: create(:campaign, master: master)) }
    subject(:policy) { described_class.new(master, vinculo) }

    it { is_expected.to permit_actions(%i[create destroy]) }
    it { is_expected.to forbid_action(:update) }
  end

  describe 'dono do personagem' do
    let(:vinculo) { create(:campaign_character, character: create(:character, user: user)) }

    it { is_expected.to permit_actions(%i[update destroy]) }
    it { is_expected.to forbid_action(:create) }
  end

  describe 'admin' do
    let(:admin) { create(:user, :admin) }
    subject(:policy) { described_class.new(admin, vinculo) }

    it { is_expected.to permit_actions(%i[create update destroy]) }
  end

  describe 'outro usuário' do
    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end
end
