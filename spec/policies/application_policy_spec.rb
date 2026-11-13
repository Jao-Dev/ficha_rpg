require 'rails_helper'

describe ApplicationPolicy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { create(:user) }
  let(:record) { nil }

  it { is_expected.to forbid_actions(%i[index show new create edit update destroy]) }

  context 'sem usuário' do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[index show new create edit update destroy]) }
  end

  describe 'admin?' do
    it 'verdadeiro para admin' do
      admin = create(:user, :admin)

      expect(described_class.new(admin, nil).send(:admin?)).to be(true)
    end

    it 'falso sem usuário' do
      expect(described_class.new(nil, nil).send(:admin?)).to be(false)
    end
  end

  describe 'escopo' do
    it 'levanta erro quando não definido' do
      expect { described_class::Scope.new(user, Object).resolve }
        .to raise_error(NoMethodError, /You must define #resolve/)
    end
  end
end
