require 'rails_helper'

describe Character do
  describe 'Validacoes' do
      it { is_expected.not_to have_valid(:name).when(nil, '') }
      it { is_expected.not_to have_valid(:race).when(nil, '') }
      it { is_expected.not_to have_valid(:ativo).when(nil, '') }
  end

  describe 'validar imagem do avatar' do
    it 'sendo imagem PNG' do
      character = build(:character)
      character.avatar.attach(
        io: Rails.root.join('spec/resources/dummies/dummy.png').open,
        filename: 'dummy.png'
      )
      expect(character).to be_valid
    end

    it 'sendo imagem HEIC' do
      character = build(:character)
      character.avatar.attach(
        io: Rails.root.join('spec/resources/dummies/dummy.heic').open,
        filename: 'dummy.png'
      )
      expect(character).not_to be_valid
    end

    it 'arquivo inválido sem extensão' do
      character = build(:character)
      character.avatar.attach(
        io: Rails.root.join('spec/resources/pdf-sem-extensao').open,
        filename: 'pdf-sem-extensao'
      )
      expect(character).not_to be_valid
    end
  end
end
