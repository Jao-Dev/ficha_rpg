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

  describe 'role' do
    it 'padrão é jogador' do
      expect(User.new.role).to eq 'jogador'
    end

    it 'pode ser mestre' do
      expect(build(:user, role: :mestre)).to be_mestre
    end

    it 'pode ser admin' do
      expect(build(:user, role: :admin)).to be_admin
    end
  end

  describe 'to_s' do
    it 'é o nome' do
      expect(build(:user, name: 'Arador').to_s).to eq 'Arador'
    end
  end
end
