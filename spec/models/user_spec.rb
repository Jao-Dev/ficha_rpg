require 'rails_helper'

describe User do
  describe 'Validacoes' do
      it { is_expected.not_to have_valid(:name).when(nil, '') }
      it { is_expected.not_to have_valid(:email).when(nil, '') }
  end

  describe 'Criando novo usuário' do
    it 'sem email' do
      u = build(:user, email: nil)
      expect(u).not_to be_valid
    end
  end
end
