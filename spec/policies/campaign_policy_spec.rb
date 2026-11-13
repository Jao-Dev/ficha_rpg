require 'rails_helper'

describe CampaignPolicy do
  subject(:policy) { described_class.new(user, campaign) }

  let(:user) { create(:user) }
  let(:campaign) { create(:campaign) }

  it { is_expected.to permit_actions(%i[show create]) }

  describe 'admin' do
    it { is_expected.to permit_actions(%i[show create]) }
  end
end
