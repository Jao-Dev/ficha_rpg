require 'rails_helper'

describe CharacterPolicy do
  subject(:policy) { described_class.new(user, character) }

  describe 'dono do personagem' do
    let(:user) { create(:user) }
    let(:character) { create(:character, user: user) }

    it { is_expected.to permit_actions(%i[show edit update destroy alternar]) }
    it { is_expected.to permit_action(:create) }
  end

  describe 'mestre da campanha do personagem' do
    let(:master) { create(:user) }
    let(:character) { create(:character, user: create(:user), campaign: create(:campaign, master:)) }
    subject(:policy) { described_class.new(master, character) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_actions(%i[edit update destroy alternar create]) }
  end

  describe 'admin' do
    let(:admin) { create(:user, :admin) }
    let(:character) { create(:character, user: create(:user)) }
    subject(:policy) { described_class.new(admin, character) }

    it { is_expected.to permit_actions(%i[show edit update destroy alternar create]) }
  end

  describe 'outro usuário' do
    let(:user) { create(:user) }
    let(:character) { create(:character) }

    it { is_expected.to forbid_actions(%i[show edit update destroy alternar create]) }
  end
end
